# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/oktopartial/publications/show.html.erb" do
  include Oktopartial::PublicationsHelper
  before(:each) do
    assigns[:publication] = @publication = stub_model(Oktopartial::Publication,
      :dirname => "20091006104200",
      :status_cd => "0"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/20091006104200/)
    response.should have_text(/公開準備中/)
  end
end
