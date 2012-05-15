class Oktopartial::PublicationsController < ApplicationController
  unloadable

  # GET /oktopartial/publications
  # GET /oktopartial/publications.xml
  def index
    @publications = Oktopartial::Publication.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @publications }
    end
  end

  # GET /oktopartial/publications/1
  # GET /oktopartial/publications/1.xml
  def show
    @publication = Oktopartial::Publication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @publication }
    end
  end

  # GET /oktopartial/publications/new
  # GET /oktopartial/publications/new.xml
  def new
    @publication = Oktopartial::Publication.new
    @publication.dest_dir = params[:dest_dir] || '/'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @publication }
    end
  end

  # GET /oktopartial/publications/1/edit
  def edit
    @publication = Oktopartial::Publication.find(params[:id])
  end

  # POST /oktopartial/publications
  # POST /oktopartial/publications.xml
  def create
    @publication = Oktopartial::Publication.new(params[:publication])

    respond_to do |format|
      if @publication.save
        flash[:notice] = 'Oktopartial::Publication was successfully created.'
        format.html { redirect_to(:action => :show, :id => @publication.id) }
        format.xml  { render :xml => @publication, :status => :created, :location => @publication }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /oktopartial/publications/1
  # PUT /oktopartial/publications/1.xml
  def update
    @publication = Oktopartial::Publication.find(params[:id])

    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        flash[:notice] = 'Oktopartial::Publication was successfully updated.'
        format.html { redirect_to(:action => :show, :id => @publication.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /oktopartial/publications/1
  # DELETE /oktopartial/publications/1.xml
  def destroy
    @publication = Oktopartial::Publication.find(params[:id])
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { head :ok }
    end
  end

  # GET /oktopartial/publications/download/1
  def download
    publication = Oktopartial::Publication.find(params[:id])
    send_file(publication.actual_source_path)
  end

  # POST /oktopartial/publications/prepare/1
  def prepare
    publication = Oktopartial::Publication.find(params[:id])
    publication.prepare!
    redirect_to :back
  end

  # POST /oktopartial/publications/publish/1
  def publish
    publication = Oktopartial::Publication.find(params[:id])
    publication.publish!
    if publication.status_key == :published
      redirect_to :controller => "oktopartial/contents", :action => :index
    else
      redirect_to :back
    end
  end

  # GET /oktopartial/publications/preview/1
  def preview
    publication = Oktopartial::Publication.find(params[:id])
    path = File.join(publication.actual_dir_path, params[:path])
    unless File.exist?(path)
      send_file File.join(RAILS_ROOT, '/public/404.html'), :type => 'text/html; charset=utf-8', :status => 404
      return
    end
    mime_type = Oktopartial::MimeType.by_extname(File.extname(path))
    discrete_type = Oktopartial::MimeType.discrete_type_by_mime_type(mime_type)
    logger.debug(path)
    if request.xhr?
      url = url_for(:action => :preview, :id => publication.id, :path => params[:path])
      render(:text => ("<iframe frameborder='0' width='100%' height='100%' border='0' src='#{url}'/>"))
    else
      case discrete_type
      when :text, :image then 
        send_file(path, :disposition => 'inline', :type => mime_type)
      else 
        send_file(path)
      end
    end
  end

end
