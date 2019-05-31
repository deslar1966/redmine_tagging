module TaggingPlugin

  module ProjectsHelperPatch
    module WithTags
      def project_settings_tabs
        tabs = super
        tabs << { name: 'tags', partial: 'tagging/tagtab', label: :tagging_tab_label }
        return tabs
      end
    end 
  end

  module WikiControllerPatch
    module WithTags
      def update
        if params[:wiki_page]
          if tags = params[:wiki_page][:tags]
            tags = TagsHelper.from_string(tags)
            @page.tags_to_update = tags
          end
        end
        super
      end
    end
  end
end

WikiController.prepend(TaggingPlugin::WikiControllerPatch::WithTags) unless WikiController.included_modules.include? TaggingPlugin::WikiControllerPatch
ProjectsHelper.prepend(TaggingPlugin::ProjectsHelperPatch::WithTags) unless ProjectsHelper.included_modules.include? TaggingPlugin::ProjectsHelperPatch
