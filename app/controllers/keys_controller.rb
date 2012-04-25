class KeysController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json, :xml
  before_filter :find_id, :only => [:show, :destroy]

  def index
    @keys = current_user.keys.all
    respond_with(@keys)
  end

  def new
    @key = current_user.keys.new
    respond_with(@key)
  end

  def create
    @key = current_user.keys.new(params[:key])

    Key.transaction do
      @key.save!
      @key.update_repository
    end

    respond_with(@key)
  end

  def show
    respond_with(@key)
  end

  def destroy
    @key.destroy

    respond_with(@key)
  end

  private
  def find_id
    @key = current_user.keys.find(params[:id])
  end
end
