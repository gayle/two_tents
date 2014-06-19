module ErrorMessagesHelper
# Render error messages for the given objects.
# The :message and :header_message options are allowed.
  def error_messages_for(object)
    messages = object.errors.full_messages
    unless messages.empty?
      content_tag(:div, :class => "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:ul, list_items.join.html_safe)
      end
    end

    # when param is *objects
    #messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    #unless messages.empty?
    #  content_tag(:div, :class => "error_messages") do
    #    list_items = messages.map { |msg| content_tag(:li, msg) }
    #    content_tag(:ul, list_items.join.html_safe)
    #  end
    #end



    # when param is params*
    #options = params.extract_options!.symbolize_keys
    #
    #objects = Array.wrap(options.delete(:object) || params).map do |object|
    #  object = instance_variable_get("@#{object}") unless object.respond_to?(:to_model)
    #  object = convert_to_model(object)
    #
    #  if object.class.respond_to?(:model_name)
    #    options[:object_name] ||= object.class.model_name.human.downcase
    #  end
    #
    #  object
    #end
  end
end
