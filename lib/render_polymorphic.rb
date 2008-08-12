module RenderPolymorphic
  def self.included(base)
    base.send(:include, SingletonMethods)
    base.class_eval do
      alias_method_chain :render, :polymorphic
    end
  end
  
  module SingletonMethods
    def render_with_polymorphic(options = {}, old_local_assigns = {}, &block)
      if options.is_a?(Hash) && ivar = options.delete(:polymorphic)
        name = ivar.class.to_s.tableize
        partial = "#{name}/#{controller.controller_name}_#{controller.action_name}"
        partial << "_#{options.delete(:suffix)}" if options[:suffix]
        render_without_polymorphic(options.update(:partial => partial), old_local_assigns, &block)
      else
        render_without_polymorphic(options, old_local_assigns, &block)
      end
    end
  end
end