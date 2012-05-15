class RequestSendingsController < ApplicationController
  # GET /request_sendings
  # GET /request_sendings.xml
  def index
    @request_sendings = RequestSending.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @request_sendings }
    end
  end

  # GET /request_sendings/1
  # GET /request_sendings/1.xml
  def show
    @request_sending = RequestSending.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @request_sending }
    end
  end

  # GET /request_sendings/new
  # GET /request_sendings/new.xml
  def new
    @request_sending = RequestSending.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @request_sending }
    end
  end

  # GET /request_sendings/1/edit
  def edit
    @request_sending = RequestSending.find(params[:id])
  end

  # POST /request_sendings
  # POST /request_sendings.xml
  def create
    @request_sending = RequestSending.new(params[:request_sending])

    respond_to do |format|
      if @request_sending.save
        flash[:notice] = 'RequestSending was successfully created.'
        format.html { redirect_to(@request_sending) }
        format.xml  { render :xml => @request_sending, :status => :created, :location => @request_sending }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @request_sending.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /request_sendings/1
  # PUT /request_sendings/1.xml
  def update
    @request_sending = RequestSending.find(params[:id])

    respond_to do |format|
      if @request_sending.update_attributes(params[:request_sending])
        flash[:notice] = 'RequestSending was successfully updated.'
        format.html { redirect_to(@request_sending) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @request_sending.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /request_sendings/1
  # DELETE /request_sendings/1.xml
  def destroy
    @request_sending = RequestSending.find(params[:id])
    @request_sending.destroy

    respond_to do |format|
      format.html { redirect_to(request_sendings_url) }
      format.xml  { head :ok }
    end
  end
end
