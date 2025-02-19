# frozen_string_literal: true

module ApiErrors
  extend ActiveSupport::Concern

  def unauthorized_error
    render(
      json: {
        status: 401,
        error: 'Unauthorized',
      },
      status: :unauthorized,
    )
  end

  def validation_errors(errors:)
    render(
      json: {
        status: 422,
        error: 'Unprocessable Entity',
        code: 'validation_errors',
        error_details: errors,
      },
      status: :unprocessable_entity,
    )
  end

  def forbidden_error(code:)
    render(
      json: {
        status: 403,
        error: 'Forbidden',
        code:,
      },
      status: :forbidden,
    )
  end

  def method_not_allowed_error(code:)
    render(
      json: {
        status: 405,
        error: 'Method Not Allowed',
        code:,
      },
      status: :method_not_allowed,
    )
  end

  def render_error_response(error_result)
    case error_result.error
    when BaseService::NotFoundFailure
      not_found_error(resource: error_result.error.resource)
    when BaseService::MethodNotAllowedFailure
      method_not_allowed_error(code: error_result.error.code)
    when BaseService::ValidationFailure
      validation_errors(errors: error_result.error.messages)
    when BaseService::ForbiddenFailure
      forbidden_error(code: error_result.error.code)
    else
      raise(error_result.error)
    end
  end
end
