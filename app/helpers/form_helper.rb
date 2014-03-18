module FormHelper
  def self.included(base)
    ActionView::Helpers::FormBuilder.instance_eval do
      include FormBuilderMethods
    end
  end
 
  module FormBuilderMethods
    def currency(method, options={class: "currency_convert"})
      config = {live: false, allow_blank: false}
      config.merge!(options)
      added_classes = options[:class] + " currency_convert" if options.has_key?(:class)
      added_classes = added_classes + " live_edit" if config[:live] == true
      added_classes = added_classes + " allow_blank" if config[:allow_blank] == true
      options[:class] = added_classes
      options[:id] = "#{@object_name}_#{method}"
      options[:name] = "#{@object_name}[#{method}]"
      options.delete(:live)
      options.delete(:allow_blank)
      @template.text_field method, self, options
    end
  end
end