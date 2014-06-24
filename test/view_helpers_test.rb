require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include X::Editable::Rails::ViewHelpers

  class Subject < OpenStruct
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    def initialize(attributes={})
      super(attributes.merge(id: 1, name: "test subject"))
    end

    def to_param
      "#{id}-#{name}".parameterize
    end
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
