class TurboReplacer
  def self.call(controller_instance:, dom_target:, partial:, locals: {})
    controller_instance.render(turbo_stream: controller_instance.view_context.turbo_stream.replace(
                                                dom_target,
                                                partial: partial,
                                                locals: locals
                                              )
    )
  end
end
