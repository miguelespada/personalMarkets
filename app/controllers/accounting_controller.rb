class AccountingController < ApplicationController

  UserPayback = Struct.new(:user_id)

  def new
    @user_payback = UserPayback.new user_id
  end

  def pay
    AccountingDomain.pay user_id, amount
    redirect_to user_accounting_path user
  end

  def show
    @accounting = AccountingDomain.for_user user_id
  end

private

  def user_id
    params[:user_id]
  end

  def user
    User.find user_id
  end

  def amount
    params[:amount].to_f
  end

end