require 'spec_helper'

describe Admin::TemplatesController do
  before(:each) { login_as Factory(:user) }

  describe '#edit' do
    describe '#association_group' do
      it 'returns an array of the theme, template and field' do
        field = Factory(:field)
        association_group = [field.template.theme, field.template, field]
        params = {
          :theme_id => field.template.theme.id,
          :id => field.template.id
        }

        get :edit, params
        controller.association_group(field).should == association_group
      end
    end
  end

  describe '#update' do
    context 'when the position of the fields are posted' do
      before(:each) do
        @template = Factory(:template)
        @field_1 = Factory(:field, :template => @template)
        field_type = @field_1.field_type
        @field_2 = Factory(:field, :template => @template, :field_type => field_type)
        @field_3 = Factory(:field, :template => @template, :field_type => field_type)

        params = { :theme_id => @template.theme.id, :id => @template.id }
        params[:position] = [@field_3.id, @field_2.id, @field_1.id]

        put :update, params
      end

      it 'reorders field_3 in position 1' do
        @template.fields[0].should == @field_3
      end

      it 'reorders field_2 in position 2' do
        @template.fields[1].should == @field_2
      end

      it 'reorders field_1 in position 3' do
        @template.fields[2].should == @field_1
      end
    end

    context 'when the template content is posted' do
      before(:each) do
        @template = Factory(:template)
        @content = '<h1>{{ site.name }}</h1>'
        params = { :theme_id => @template.theme.id, :id => @template.id }
        params[:template] = { :content => @content }

        put :update, params
      end

      it 'updates the template conte field' do
        # the content attribute is set when Factory runs, so a reload
        # is needed to fetch the updated value
        @template.reload
        @template.content.should == @content
      end

      it 'redirects the user to the theme show view' do
        response.should redirect_to admin_manage_theme_path(@template.theme)
      end
=begin
      it 'returns a status of OK' do
        response.status.should == 200
      end

      it 'does not render anything' do
        response.body.strip.empty?.should == true
      end
=end
    end
  end
end
