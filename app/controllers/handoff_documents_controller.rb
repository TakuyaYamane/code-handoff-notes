class HandoffDocumentsController < ApplicationController
  before_action :set_repository
  before_action :set_handoff_document, only: [:show, :edit, :update]

  def show
  end

  def new
    @handoff_document = @repository.build_handoff_document
  end

  def create
    @handoff_document = @repository.build_handoff_document(handoff_document_params)

    if @handoff_document.save
      redirect_to repository_handoff_document_path(@repository), notice: "Handoff document was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @handoff_document.update(handoff_document_params)
      redirect_to repository_handoff_document_path(@repository), notice: "Handoff document was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_repository
    @repository = Repository.find(params[:repository_id])
  end

  def set_handoff_document
    @handoff_document = @repository.handoff_document
  end

  def handoff_document_params
    params.require(:handoff_document).permit(
      :overview,
      :features,
      :database_notes,
      :environment_notes,
      :setup_notes,
      :operation_notes,
      :risks
    )
  end
end