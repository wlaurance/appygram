if Delayed::Worker.method_defined? :handle_failed_job
  class Delayed::Worker
    def handle_failed_job_with_appygram(job, e)
      Appygram.handle(e, "Delayed::Job #{job.name}")
      handle_failed_job_without_appygram(job, e)
      Appygram.context.clear!
    end
    alias_method_chain :handle_failed_job, :appygram
    Appygram.logger.info "DJ integration enabled"
  end
else
  message = "\n\n\nThe Appygram gem does not support Delayed Job 1.8.4 or earlier.\n\n\n"
  STDERR.puts(message)
  Appygram.logger.error(message)
end
