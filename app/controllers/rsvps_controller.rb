class RsvpsController < ApplicationController
	def index
	end
	def show
		@user = Rsvp.find_by(name: params[:name].humanize.titleize)
		redirect_to(root_url, :notice => 'Record not found') unless @user
	end
	def update
		@user = Rsvp.find(params[:id])
		@user.update(rsvp_params)
		redirect_back fallback_location: root_url
	end

	def admin_index
		authentication_required!
		@invitees = Rsvp.order(:name)
		@rsvp = Rsvp.new
	end
	def create
		authentication_required!
		@rsvp = Rsvp.new(rsvp_params)
		if @rsvp.save
			redirect_to rsvps_admin_path
		else
			render :admin_index
		end
	end
	def destroy
		authentication_required!
		Rsvp.find(params[:id]).destroy
		redirect_to rsvps_admin_path
	end
	def email
		authentication_required!
		RsvpMailer.invite_email(params[:id]).deliver!
		redirect_to rsvps_admin_path
	end
	private
		def rsvp_params
			params.require(:rsvp).permit(:name, :has_rsvpd, :is_attending, :email)
		end
end