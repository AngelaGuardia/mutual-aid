class OffersController < PublicController
  def index
    redirect_to contributions_public_path
  end

  def new
    serialize(Submission.new)
  end

  def create
    submission = SubmissionForm.build submission_params

    if submission.save
      redirect_to contribution_thank_you_path, notice: 'Offer was successfully created.'
    else
      serialize(submission)
      render :new
    end
  end

  private

    def submission_params
      params[:submission].tap do |p|
        p[:form_name] = 'Offer_form'
        p[:listing_attributes][:type] = 'Offer'
      end
    end

    def serialize(submission)
      @json = {
        submission: SubmissionBlueprint.render_as_hash(submission),
        configuration: ConfigurationBlueprint.render_as_hash(nil),
      }.to_json
    end
end
