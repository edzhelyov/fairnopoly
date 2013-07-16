require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "mass-upload" do

  let (:private_user) { FactoryGirl.create :private_user }
  let (:legal_entity_user) { FactoryGirl.create :legal_entity }

  subject { page }

  # bugbug I still don't really get the difference between describe & context
  context "for non signed-in users" do
    it "should rediret to login page" do
      visit new_mass_upload_path
      current_path.should eq new_user_session_path
      should have_selector(:link_or_button, text: 'Login')
    end
  end

  context "for signed-in private users" do

    before do
      login_as private_user
      visit new_article_path
    end

    it "should not have a csv upload link" do
      should_not have_link(I18n.t('mass_upload.labels.upload_article_via_csv'), href: new_mass_upload_path)
    end
  end


  context "for signed-in legal entity users" do

    before do
      login_as legal_entity_user
      visit new_article_path
    end

    it "should have a csv upload link" do
      should have_link(I18n.t('mass_upload.labels.upload_article_via_csv'), href: new_mass_upload_path)
    end

    context "uploading" do
      before do
        setup_categories
        click_link I18n.t('mass_upload.labels.upload_article_via_csv')
      end

      context "with missing payment data -" do
        before do
          attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv')
          click_button I18n.t('mass_upload.labels.upload_article')
        end

        describe "any payment data" do
          it "should show the correct error message" do
            page.html.should include(I18n.t('mass_upload.errors.missing_payment_details',
              missing_payment: I18n.t('formtastic.labels.user.paypal_and_bank_account'),
              link: edit_user_registration_path(legal_entity_user) + '#profile_step'))
          end
        end

        describe "paypal data" do
          let (:legal_entity_user) { FactoryGirl.create :legal_entity, :bank_data }
          it "should show the correct error message" do
            page.html.should include(I18n.t('mass_upload.errors.missing_payment_details',
              missing_payment: I18n.t('formtastic.labels.user.paypal_account'),
              link: edit_user_registration_path(legal_entity_user) + '#profile_step'))
          end
        end

        describe "bank data" do
          let (:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }
          it "should show the correct error message" do
            page.html.should include(I18n.t('mass_upload.errors.missing_payment_details',
              missing_payment: I18n.t('formtastic.labels.user.bank_account'),
              link: edit_user_registration_path(legal_entity_user) + '#profile_step'))
          end
        end
      end

      context "with complete payment data" do
        let (:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data, :bank_data }

        context "and a valid csv file" do
          before { attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv') }

          it "should redirect to the mass_uploads#show" do
            click_button I18n.t('mass_upload.labels.upload_article')
            should have_content('dummytitle1')
            should have_selector('input.Btn.Btn--green.Btn--greenSmall')
            should have_xpath("/html/body/div[4]/div/ul/a[1]/form/div/input
              [contains(@value, '#{I18n.t('article.labels.submit')}')]
              ")
          end

          it "should create new articles" do
            # bugbug Not dry, but how to use expect I need to click the button again, right?
            visit new_mass_upload_path
            attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv')
            expect { click_button I18n.t('mass_upload.labels.upload_article') }.to change(Article, :count).by(2)
          end

          describe "activate articles" do

            before { click_button I18n.t('mass_upload.labels.upload_article') }

            it "should disable a activate article button after it is clicked" do
              # bugbug xpath is used because of identical buttons
              page.find(:xpath, "/html/body/div[4]/div/ul/a[1]/form/div/input[2]").click
              should have_selector('input.Btn.Btn--green.Btn--greenSmall')
              should have_selector('a.Btn.Btn--red.Btn--redSmall')
            end

            it "should redirect to the user#offers when activating all articles" do
              click_button I18n.t('mass_upload.labels.mass_activate_articles')
              should_not have_selector('h1', text: I18n.t('mass_upload.titles.uploaded_articles'))
              should have_selector('a', text: Article.last.title)
            end

            it "going back to mass_uploads#show it should show changed buttons" do
              # bugbug To much/wrong way to get back to mass_uploads#show?
              secret_mass_uploads_number = current_path.delete "/mass_uploads/"
              click_button I18n.t('mass_upload.labels.mass_activate_articles')
              visit mass_upload_path(secret_mass_uploads_number)
              should_not have_selector('input.Btn.Btn--green.Btn--greenSmall')
              should have_content I18n.t('mass_upload.labels.all_articles_activated')
            end
          end
        end

        context "a csv file with a wrong header" do
          before { attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_header.csv') }

          it "should show correct error messages" do
            click_button I18n.t('mass_upload.labels.upload_article')
            should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.wrong_header'))
          end

          it "should not create new articles" do
            expect { click_button I18n.t('mass_upload.labels.upload_article') }.not_to change(Article, :count)
          end
        end

        context "a csv file with a wrong articles" do
          before { attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_article.csv') }

          it "should show correct error messages" do
            click_button I18n.t('mass_upload.labels.upload_article')
            should have_selector('p.inline-errors',
              text: I18n.t('mass_upload.errors.wrong_article',
              # bugbug Alternativen dazu eine einmalige "Sondermessage" ins Internationalization file zu schreiben ('wrong_article_message')
                message: I18n.t('mass_upload.errors.wrong_article_message'),
                index: 2))
          end

          it "should not create new articles" do
            expect { click_button I18n.t('mass_upload.labels.upload_article') }.not_to change(Article, :count)
          end
        end

        context "a file with the wrong format" do
          it "should show correct error messages" do
            attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_format.html')
            click_button I18n.t('mass_upload.labels.upload_article')
            should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.missing_file'))
          end
        end

        context "without selecting a file" do
          it "should show correct error messages" do
            click_button I18n.t('mass_upload.labels.upload_article')
            should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.missing_file'))
          end
        end
      end
    end
  end
end
