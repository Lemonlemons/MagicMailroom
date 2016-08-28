class MailJob < ActiveJob::Base
  queue_as :MagicMailroom-Queue
end
