module KnifeCookbookDoc
  class DefaultLicenseFormatter
    def format(model)
      lines = []
      lines << "Maintainer:: #{model.maintainer} (<#{model.maintainer_email}>)"
      lines << "Source:: #{model.source_url}" unless model.source_url.empty?
      lines << "Issues:: #{model.issues_url}" unless model.issues_url.empty?
      lines << "License:: #{model.license}"
      lines.join "\n\n"
    end
  end
end
