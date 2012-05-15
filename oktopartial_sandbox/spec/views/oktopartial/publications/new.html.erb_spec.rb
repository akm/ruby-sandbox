require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/oktopartial/publications/new.html.erb" do
  include Oktopartial::PublicationsHelper

  before(:each) do
    assigns[:publication] = stub_model(Oktopartial::Publication,
      :new_record? => true,
      :dirname => "20091006104400",
      :status_cd => "0"
    )
  end

  it "renders new publication form" do
    render

    response.should have_tag("form[action=?][method=post]", url_for(:controller => 'oktopartial/publications', :action => :create)) do
      with_tag("input#publication_uploaded_file[name=?]", "publication[uploaded_file]")
      with_tag('select#publication_published_at_1i[name=?]', "publication[published_at(1i)]")
      with_tag('select#publication_published_at_2i[name=?]', "publication[published_at(2i)]")
      with_tag('select#publication_published_at_3i[name=?]', "publication[published_at(3i)]")
      with_tag('select#publication_published_at_4i[name=?]', "publication[published_at(4i)]")
      with_tag('select#publication_published_at_5i[name=?]', "publication[published_at(5i)]")
    end
  end
end
