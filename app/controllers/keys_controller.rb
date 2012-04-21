class KeysController < ApplicationController
  respond_to :html
  before_filter :find_id, :only => [:show]

  def index
    @keys = current_user.keys.all
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

  def find_id
    @key = current_user.keys.find(params[:id])
  end
end
