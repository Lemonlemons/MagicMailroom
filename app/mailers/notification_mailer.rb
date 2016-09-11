class NotificationMailer < ApplicationMailer
  default from: ENV["MAILER_SENDER"]

  def notification_email(resident, company)
    @resident = resident
    @company = company
    mail(to: @resident.email, subject: @company.email_subject_line)
  end

  def welcome_email(resident, company)
    @resident = resident
    @company = company
    mail(to: @resident.email, subject: @company.name + " welcomes you to our new delivery notification system.")
  end
end
