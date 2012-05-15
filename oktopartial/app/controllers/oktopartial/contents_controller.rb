class Oktopartial::ContentsController < ApplicationController
  unloadable

  # POST /oktopartial_contents
  # POST /oktopartial_contents.xml
  def update_all
    Oktopartial::Content.update_all
    redirect_to :action => :index
  end

  # GET /oktopartial_contents
  # GET /oktopartial_contents.xml
  def index
    @dir = params[:dir]
    if request.xhr?
      @contents = Oktopartial::Content.send(*(@dir ? [:under, @dir] : [:all]))
      render :partial => 'table' if request.xhr?
      return
    end

    @dirs = Oktopartial::Content.directories_from
    @contents = Oktopartial::Content.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contents }
    end
  end

  # GET /oktopartial_contents/1
  # GET /oktopartial_contents/1.xml
  def show
    @content = Oktopartial::Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /oktopartial_contents/new
  # GET /oktopartial_contents/new.xml
  def new
    @content = Oktopartial::Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /oktopartial_contents/1/edit
  def edit
    @content = Oktopartial::Content.find(params[:id])
  end

  # POST /oktopartial_contents
  # POST /oktopartial_contents.xml
  def create
    @content = Oktopartial::Content.new(params[:content])

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Oktopartial::Content was successfully created.'
        format.html { redirect_to(:action => :show, :id => @content.id) }
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /oktopartial_contents/1
  # PUT /oktopartial_contents/1.xml
  def update
    @content = Oktopartial::Content.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Oktopartial::Content was successfully updated.'
        format.html { redirect_to(:action => :show, :id => @content.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /oktopartial_contents/1
  # DELETE /oktopartial_contents/1.xml
  def destroy
    @content = Oktopartial::Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { head :ok }
    end
  end
end
