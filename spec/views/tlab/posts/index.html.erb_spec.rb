require 'spec_helper'

describe "tlab/posts/index" do
  before(:each) do
    assign(:posts, [
      stub_model(Tlab::Post,
        :title => "Title",
        :preview => "Preview",
        :published_at => DateTime.parse("2000-01-01"),
        :author => nil
      ),
      stub_model(Tlab::Post,
        :title => "Title",
        :preview => "Preview",
        :published_at => DateTime.parse("2000-01-01"),
        :author => nil
      )
    ])
    view.stub(:can?).and_return false
  end

  it "renders a heading with the title" do
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    render

    assert_select "heading h3", :text => "Title".to_s, :count => 2
  end

  it "renders an article with the preview" do
    render

    assert_select "article", :text => "Preview".to_s, :count => 2
  end

  it "renders the published date" do
    render

    assert_select ".tlab-post-publishedAt", text: ( l DateTime.parse("2000-01-01") ), count: 2
  end

  it "does not render an edit or delete button" do
    render

    assert_select ".tlab-post-btn-edit", count: 0
    assert_select ".tlab-post-btn-delete", count: 0
  end

  it "does not render a new page button" do
    render

    assert_select ".tlab-post-btn-new", count: 0
  end

  context "user can manage post" do
    before(:each) { view.stub(:can?).and_return true }

    it "renders a new page button" do
      render

      assert_select ".tlab-post-btn-new", count: 1
    end

    it "renders an edit or delete button" do
      render

      assert_select ".tlab-post-btn-edit", count: 2
      assert_select ".tlab-post-btn-delete", count: 2
    end
  end
end
