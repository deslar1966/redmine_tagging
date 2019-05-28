module TaggingPlugin

  module ProjectsHelperPatch
    module ProjectSettingsTabsWithTagsTab
      def project_settings_tabs
        tabs = super
        tabs << { name: 'tags', partial: 'tagging/tagtab', label: :tagging_tab_label }
        return tabs
      end
    end 
    
    #class InstanceMethods
    #  prepend ProjectSettingsTabsWithTagsTab
    #end

  end

  module WikiControllerPatch
    module UpdateWithTags
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
   
    #class InstanceMethods
    #  prepend UpdateWithTags
    #end

  end
end

#WikiController.send(:include, TaggingPlugin::WikiControllerPatch) unless WikiController.included_modules.include? TaggingPlugin::WikiControllerPatch
#ProjectsHelper.send(:include, TaggingPlugin::ProjectsHelperPatch) unless ProjectsHelper.included_modules.include? TaggingPlugin::ProjectsHelperPatch
WikiController.prepend(TaggingPlugin::WikiControllerPatch::UpdateWithTags) unless WikiController.included_modules.include? TaggingPlugin::WikiControllerPatch
ProjectsHelper.prepend(TaggingPlugin::ProjectsHelperPatch::ProjectSettingsTabsWithTagsTab) unless ProjectsHelper.included_modules.include? TaggingPlugin::ProjectsHelperPatch
