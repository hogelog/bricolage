module Bricolage

  ##
  # Common super-class of handlable bricolage exceptions
  class ApplicationError < StandardError; end

  ##
  # Job failure.
  # This exception may occur in production environment and is temporary.
  # e.g. Source data error, SQL error
  class JobFailure < ApplicationError; end

  ##
  # various SQL exception
  class SQLException < JobFailure
    def SQLException.wrap(ex)
      new(ex.message, ex)
    end

    def initialize(msg, orig = nil)
      super msg
      @original = orig
    end

    attr_reader :original
  end

  ##
  # Aquiring lock takes too long (e.g. VACUUM lock)
  class LockTimeout < JobFailure; end

  ##
  # Job error.
  # This exception should NOT be thrown in production environment.
  # Developer must fix source code or configuration, not to be get this exception.
  class JobError < ApplicationError; end

  ##
  # Command-line option errors (should NOT be thrown in production environment)
  class OptionError < JobError; end

  ##
  # User parameter errors (should NOT be thrown in production environment)
  class ParameterError < JobError; end

  ##
  # Job net aborted by any failure or error
  class JobNetSessionAborted < ApplicationError
    def initialize(jobnet, result)
      super "jobnet #{jobnet.id} aborted: cause=#{result.job.ref}"
      @jobnet = jobnet
      @result = result
    end

    attr_reader :jobnet
    attr_reader :result
  end

  ##
  # Bad code in bricolage core or job classes.
  # This exception should NOT be thrown in ANY user environment.
  class FatalError < Exception; end

end
