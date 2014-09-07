require 'pony'

class ContactController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    ContactDomain.send contact_params
    redirect_to root_path, notice: I18n.t(:form_sent_successfully) 
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :description)
  end

end

class ContactDomain

  def self.send contact_params
    Pony.mail(
      :from => %("#{contact_params[:name]}" <#{contact_params[:email]}>), 
      :subject => contact_params[:subject], 
      :body => %(Email by: "#{contact_params[:name]}" <#{contact_params[:email]}> Message: #{contact_params[:description]}))
  end

end

