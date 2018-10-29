require 'rails_helper'

RSpec.describe IdeasController, type: :controller do
  def current_user
    @current_user ||= FactoryBot.create(:user)
  end

  def idea
    @idea ||= FactoryBot.create(:idea)
  end

  describe("#new") do
    context("without user signed in") do
      it("redirects to the sign in page") do
        get(:new)
        expect(response).to(redirect_to(new_session_path))
      end

      it("sets a danger flash") do
        get(:new)
        expect(flash[:warning]).to be
      end
    end

    context("with user signed in") do
      before do
        session[:user_id] = current_user.id
      end

      it("renders the 'new' template") do
        get(:new)
        expect(response).to(render_template(:new))
      end

      it("sets an instance variable with a new 'idea'") do
        get(:new)
        expect(assigns(:idea)).to(be_a_new(Idea))
      end
    end
  end

  describe("#create") do
    def valid_request
      post(:create, params: { idea: FactoryBot.attributes_for(:idea) })
    end

    context("without user signed in") do
      it("redirects to the sign in page") do
        valid_request
        expect(response).to(redirect_to(new_session_path))
      end
    end

    context("with user signed in") do
      before do
        session[:user_id] = current_user.id
      end

      context("with valid params") do
        it("creates a new 'idea' in the DB") do
          count_before = Idea.count
          valid_request
          count_after = Idea.count
          expect(count_after).to eq(count_before + 1)
        end

        it("redirects to the show page of the new 'idea'") do
          valid_request
          idea = Idea.last
          expect(response).to(redirect_to(idea_path(idea)))
        end

        it("associates the new 'idea' with the current user") do
          valid_request
          expect(Idea.last.user).to eq(current_user)
        end
      end

      context("with invalid params") do
        def invalid_request
          post(
            :create, 
            params: { idea: FactoryBot.attributes_for(:idea, title: nil) }) 
        end

        it("doesn't persist an 'idea' in the DB") do
          count_before = Idea.count
          invalid_request
          count_after = Idea.count
          expect(count_after).to eq(count_before)
        end

        it("renders the 'new' template") do
          invalid_request
          expect(response).to(render_template(:new))
        end
      end
    end
  end
end
