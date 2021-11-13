SchemaRegistry.module_eval do
  def self.loader
    @loader ||= SchemaRegistry::Loader.new(schemas_root_path: Rails.root.join('schemas'))
  end
end
