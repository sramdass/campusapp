class CampusMailer < ActionMailer::Base
  default :from => "admin@campusapp.com"
   
  def email_student(student, options)
    @student = student
    @message = options[:message]
    attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => options[:to], :cc => options[:cc], :bcc => options[:bcc], :subject => options[:subject])
  end

  def email_teacher(teacher, options)
    @teacher = teacher
    @message = options[:message]
    attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => options[:to], :cc => options[:cc], :bcc => options[:bcc], :subject => options[:subject])
  end

  def password_reset(profile)
    @profile = profile
    mail :to => "satheesh.ramdass@oracle.com", :subject => "Password Reset"
  end
  
end
