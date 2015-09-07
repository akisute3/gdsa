# coding: utf-8
require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  fixtures(:all)

  describe 'ゲストユーザによるアクセス' do
    describe "GET #new" do
      it 'ログインを要求する' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST #create" do
      let(:post_params) {{skill: attributes_for(:guitar_skill), mst_level: attributes_for(:guitar_level)}}

      it 'ログインを要求する' do
        post :create, post_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'DB に新しいスキルを保存しない' do
        expect {
          post :create, post_params
        }.to_not change(Skill, :count)
      end
    end

    describe "GET #edit" do
      let(:skill) { create(:guitar_skill) }

      it 'ログインを要求する' do
        get :edit, id: skill
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "PATCH #update" do
      let(:skill) { create(:duplicate_guitar_skill) }
      let(:patch_params) {{id: skill, skill: attributes_for(:guitar_skill), mst_level: attributes_for(:guitar_level)}}

      it 'ログインを要求する' do
        patch :update, patch_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'スキルを更新しない' do
        patch :update, patch_params
        skill.reload
        expect(skill.mst_level_id).to eq(21)
      end
    end

    describe "DELETE #destroy" do
      let!(:skill) { create(:guitar_skill) }

      it 'ログインを要求する' do
        delete :destroy, id: skill
        expect(response).to redirect_to new_user_session_path
      end

      it 'スキルを削除しない' do
        expect {
          delete :destroy, id: skill
        }.to_not change(Skill, :count)
      end
    end
  end


  describe 'ログインユーザによるアクセス' do
    login_user

    describe "GET #new" do
      it '@skill に新しいスキルを割り当てる' do
        get :new
        expect(assigns(:skill)).to be_a_new(Skill)
      end

      it '@skill.mst_level に新しいレベルを割り当てる' do
        get :new
        expect(assigns(:skill).mst_level).to be_a_new(MstLevel)
      end

      it ':new テンプレートを表示する' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context '新しいスキルの場合' do
        let(:post_params) {{skill: attributes_for(:guitar_skill), mst_level: attributes_for(:guitar_level)}}

        it 'DB に新しいスキルを保存する' do
          expect {
            post :create, post_params
          }.to change(Skill, :count).by(1)
        end

        it 'skills#new にリダイレクトする' do
          post :create, post_params
          expect(response).to redirect_to new_skill_path
        end

        it 'メッセージに「登録しました」と表示する' do
          post :create, post_params
          expect(flash[:notice]).to eq 'Guitar の「凱歌の奏」を登録しました。'
        end
      end

      context '既に登録した曲の場合' do
        before do
          create(:duplicate_guitar_skill)
        end

        let(:post_params) {{skill: attributes_for(:guitar_skill), mst_level: attributes_for(:guitar_level)}}

        it 'DB の同じ曲のスキルを更新する' do
          expect {
            post :create, post_params
          }.to change{Skill.last.mst_level.id}.from(21).to(19)
        end

        it '目標が未入力だった場合は、その部分は更新しない' do
          blank_goal = {
            skill: attributes_for(:guitar_skill, goal: ''),
            mst_level: attributes_for(:guitar_level)
          }

          expect {
            post :create, blank_goal
          }.to_not change{Skill.last.goal}
        end

        it 'コメントが未入力だった場合は、その部分は更新しない' do
          blank_comment = {
            skill: attributes_for(:guitar_skill, comment: ''),
            mst_level: attributes_for(:guitar_level)
          }

          expect {
            post :create, blank_comment
          }.to_not change{Skill.last.comment}
        end

        it 'skills#new にリダイレクトする' do
          post :create, post_params
          expect(response).to redirect_to new_skill_path
        end

        it 'メッセージに「更新しました」と表示する' do
          post :create, post_params
          expect(flash[:notice]).to eq 'Guitar の「凱歌の奏」を更新しました。'
        end
      end

      context '無効な属性の場合' do
        let(:invalid_post_params) {
          {skill: attributes_for(:invalid_guitar_skill), mst_level: attributes_for(:invalid_guitar_level)}
        }

        it 'DB に新しいスキルを保存しない' do
          expect {
            post :create, invalid_post_params
          }.to_not change(Skill, :count)
        end

        it ':new テンプレートを再表示する' do
          post :create, invalid_post_params
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      let(:skill) { create(:guitar_skill) }

      it '@skill に要求されたスキルを割り当てる' do
        get :edit, id: skill
        expect(assigns(:skill)).to eq skill
      end

      it ':edit テンプレートを表示する' do
        get :edit, id: skill
        expect(response).to render_template :edit
      end
    end

    describe "PATCH #update" do
      let(:guitar_skill) { create(:duplicate_guitar_skill) }
      let(:guitar_patch_params) {
        {id: guitar_skill, skill: attributes_for(:guitar_skill), mst_level: attributes_for(:guitar_level)}
      }
      let(:invalid_guitar_patch_params) {
        {id: guitar_skill, skill: attributes_for(:invalid_guitar_skill), mst_level: attributes_for(:invalid_guitar_level)}
      }
      let(:drum_skill) { create(:duplicate_guitar_skill) }
      let(:drum_patch_params) {
        {id: drum_skill, skill: attributes_for(:drum_skill), mst_level: attributes_for(:drum_level)}
      }

      context '有効な属性の場合' do
        it '要求された @skill を取得すること' do
          patch :update, guitar_patch_params
          expect(assigns(:skill)).to eq(guitar_skill)
        end

        it 'DB のスキルを更新する' do
          patch :update, guitar_patch_params
          guitar_skill.reload
          expect(guitar_skill.mst_level_id).to eq(19)
        end

        context '更新したスキルの楽器に合わせてリダイレクト' do
          it 'Drum のスキルを更新した場合は users#drum へ' do
            patch :update, drum_patch_params
            expect(response).to redirect_to drum_user_path(1)
          end

          it 'Guitar のスキルを更新した場合は users#guitar へ' do
            patch :update, guitar_patch_params
            expect(response).to redirect_to guitar_user_path(1)
          end
        end
      end

      context '無効な属性の場合' do
        it 'スキルを更新しない' do
          patch :update, invalid_guitar_patch_params
          guitar_skill.reload
          expect(guitar_skill.mst_level_id).to eq(21)
        end

        it ':edit テンプレートを再表示する' do
          patch :update, invalid_guitar_patch_params
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:guitar_skill) { create(:guitar_skill) }
      let!(:drum_skill) { create(:drum_skill) }

      it 'DB からスキルを削除する' do
        expect {
          delete :destroy, id: guitar_skill
        }.to change(Skill, :count).by(-1)
      end

      context '削除したスキルの楽器に合わせてリダイレクト' do
        it 'Drum のスキルを削除した場合は users#drum へ' do
          delete :destroy, id: drum_skill
          expect(response).to redirect_to drum_user_path(1)
        end

        it 'Guitar のスキルを削除した場合は users#guitar へ' do
          delete :destroy, id: guitar_skill
          expect(response).to redirect_to guitar_user_path(1)
        end
      end
    end
  end


  describe 'ログインユーザによる他ユーザのスキルへのアクセス' do
    login_user

    describe "POST #create" do
      context '新しいスキルの場合' do
        let(:post_params) {{skill: attributes_for(:other_user_skill), mst_level: attributes_for(:guitar_level)}}

        it '他ユーザのスキルは保存できない' do
          post :create, post_params
          expect(Skill.last.user_id).to eq(1)
        end
      end

      context '既に登録した曲の場合' do
        let!(:skill) { create(:other_user_skill) }
        let(:post_params) {{skill: attributes_for(:other_user_skill), mst_level: attributes_for(:guitar_level)}}

        it '他ユーザのスキルは更新できない' do
          expect {
            post :create, post_params
          }.to change(Skill, :count).by(1)

          pre_skill = skill.clone
          skill.reload
          expect(skill.user_id).to eq(pre_skill.user_id)
          expect(skill.mst_level_id).to eq(pre_skill.mst_level_id)
        end
      end
    end

    describe "PATCH #update" do
      let!(:skill) { create(:duplicate_other_user_skill) }
      let(:patch_params) {{id: skill, skill: attributes_for(:other_user_skill), mst_level: attributes_for(:guitar_level)}}

      context '有効な属性の場合' do
        it '他ユーザのスキルは更新せずにエラーを表示する' do
          patch :update, patch_params
          skill.reload
          expect(skill.mst_level_id).to eq(21)
          expect(flash[:alert]).to eq '他ユーザのスキルは編集できません。'
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:skill) { create(:other_user_skill) }

      it '他ユーザのスキルは削除せずにエラーを表示する' do
        expect {
          delete :destroy, id: skill
        }.to_not change(Skill, :count)
        expect(flash[:alert]).to eq '他ユーザのスキルは削除できません。'
      end
    end
  end
end
