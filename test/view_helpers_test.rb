require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include X::Editable::Rails::ViewHelpers

  class Subject < OpenStruct
    include ActiveModel::Model

    attr_accessor :id, :name, :content

    def self.model_name
      ActiveModel::Name.new(self, nil, "Page")
    end

    def initialize(attributes={})
      super(attributes.merge(id: 1, name: "test subject"))
    end
  end

  test "editable should escape unsafe values" do
    subject = Subject.new(content: "<h1>unsafe content</h1>")
    assert_match %r{&lt;h1&gt;unsafe content&lt;/h1&gt;</span>},
                 editable(subject, :content),
                 "ViewHelpers#editable should escape unsafe content"
  end

  test "editable should NOT escape safe values" do
    subject = Subject.new(content: "<h1>html_safe'd content</h1>".html_safe)
    assert_match %r{<h1>html_safe'd content</h1></span>},
                 editable(subject, :content),
                 "ViewHelpers#editable should not escape safe content"

    subject.content = "safe content"
    assert_match %r{safe content</span>},
                 editable(subject, :content),
                 "ViewHelpers#editable should not escape safe content"
  end

  test "editable should generate content tag with html options" do
    subject = Subject.new

    assert_match %r{<span[^>]+id="subject-id"},
                 editable(subject, :name, html: { id: 'subject-id' }),
                 "ViewHelpers#editable should generate content tag with html options"

    assert_match %r{<span[^>]+name="subject\[name\]"},
                 editable(subject, :name, html: { name: 'subject[name]' }),
                 "ViewHelpers#editable should generate content tag with html options"

    assert_match %r{<span[^>]+title="First Title"},
                 editable(subject, :name, title: "First Title", html: { title: 'Second Title' }),
                 "ViewHelpers#editable should generate content tag with html options"
  end

  private

  def view_helpers_test_subject_path(subject)
    "/#{subject.to_param}"
  end

  def xeditable?(*args)
    true
  end
end
