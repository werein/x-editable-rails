require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include X::Editable::Rails::ViewHelpers

  class Subject < OpenStruct
    include ActiveModel::Model

    attr_accessor :id, :name, :content, :active

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

  test "editable should generate content tag with data attributes" do
    subject = Subject.new

    assert_match %r{<span[^>]+data-model="page"},
                 editable(subject, :name),
                 "ViewHelpers#editable should generate content tag with data attributes"

    assert_no_match %r{<span[^>]+data-model="page"},
                    editable(subject, :name, model: "custom"),
                    "ViewHelpers#editable should generate content tag with data attributes"
  end

  test "editable should generate content tag with the current value" do
    subject_1 = Subject.new(content: "foo")

    assert_match %r{<span[^>]+>foo</span>},
                 editable(subject_1, :content),
                 "ViewHelpers#editable should generate content tag with the current value"

    assert_match %r{<span[^>]+>foo</span>},
                 editable(subject_1, :content, type: "select", source: ["foo", "bar"]),
                 "ViewHelpers#editable should generate content tag with the current value"

    assert_match %r{<span[^>]+>Foo</span>},
                 editable(subject_1, :content, type: "select", source: [["foo", "Foo"], ["bar", "Bar"]]),
                 "ViewHelpers#editable should generate content tag with the current value"

    assert_match %r{<span[^>]+>Foo</span>},
                 editable(subject_1, :content, type: "select", source: { "foo" => "Foo", "bar" => "Bar" }),
                 "ViewHelpers#editable should generate content tag with the current value"

    assert_match %r{<span[^>]+>Foo</span>},
                 editable(subject_1, :content, type: "select", source: [{ text: "Foo", value: "foo" }, { text: "Bar", value: "bar" }]),
                 "ViewHelpers#editable should generate content tag with the current value"

    refute_match %r{data-source=},
                 editable(subject_1, :content, type: "select"),
                 "ViewHelpers#editable should generate content tag without source"

    subject_2 = Subject.new(active: true)

    assert_match %r{<span[^>]+>Yes</span>},
                 editable(subject_2, :active),
                 "ViewHelpers#editable should generate content tag with the current value"
  end

  test "editable should store the source url as a data attribute" do
    subject = Subject.new
    assert_match %r{<span[^>]+data-source="http://example.org"},
                 editable(subject, :name, type: "select",
                 source: "http://example.org"),
                 "ViewHelpers#editable should generate content tag with url source as a data attribute"
  end

  private

  def view_helpers_test_subject_path(subject)
    "/#{subject.to_param}"
  end

  def xeditable?(*args)
    true
  end
end
