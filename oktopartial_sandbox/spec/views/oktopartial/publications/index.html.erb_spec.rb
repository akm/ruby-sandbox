# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/oktopartial/publications/index.html.erb" do
  include Oktopartial::PublicationsHelper

  before(:each) do
    assigns[:publications] = [
      stub_model(Oktopartial::Publication,
        :dirname => "20091006104500",
        :status_cd => "1"
      ),
      stub_model(Oktopartial::Publication,
        :dirname => "20091006104600",
        :status_cd => "3"
      )
    ]
  end

  it "renders a list of oktopartial_publications" do
    render
    response.should have_tag("tr>td", "20091006104500".to_s)
    response.should have_tag("tr>td", "公開準備エラー".to_s)
    response.should have_tag("tr>td", "20091006104600".to_s)
    response.should have_tag("tr>td", "公開中".to_s)
  end
end
