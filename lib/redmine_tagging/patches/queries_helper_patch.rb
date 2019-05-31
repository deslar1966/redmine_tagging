module RedmineTagging::Patches::QueriesHelperPatch
  extend ActiveSupport::Concern
  
  def column_content(column, issue)
    value = column.value(issue)

    if array_of_issue_tags?(value)
      links = value.map do |issue_tag|
        link_to_project_tag_filter(@project, issue_tag.tag)
      end
      links.join(', ')
    else
      super(column, issue)
    end
  end

  def array_of_issue_tags?(value)
    value.class.name == 'Array' && value.first.class.name == 'IssueTag'
  end
end

QueriesHelper.prepend RedmineTagging::Patches::QueriesHelperPatch
