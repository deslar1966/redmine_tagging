require_dependency 'project'

module RedmineTagging::Patches::ProjectPatch
  extend ActiveSupport::Concern

  def tags
    ActsAsTaggableOn::Tag.
        joins(:taggings).
        joins(<<-SQL
          inner join #{Issue.table_name} issues on
            #{ActiveRecord::Base::sanitize_sql(["issues.project_id=?", id])} and
            issues.id = #{ActsAsTaggableOn::Tagging.table_name}.taggable_id
        SQL
        ).order(:name).uniq
  end

end

unless Project.included_modules.include? RedmineTagging::Patches::ProjectPatch
  Project.send :include, RedmineTagging::Patches::ProjectPatch
end
