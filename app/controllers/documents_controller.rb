class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy]

	def show
	end

	def edit
		unless current_user.is_admin?
      respond_to do |format|
         format.html { redirect_to document_path(@document), alert: "You can't edit this page." }
       end
    end
	end

	def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_document
    @document = Document.find_by_uri(params[:id])
  end

  def document_params
    params.require(:document).permit(:uri, :title, :body)
  end

end