class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_food = RecipeFood.includes(:food).all.where(recipe_id: @recipe)
  end

  def create
    recipe = Recipe.create(recipe_params)
    recipe.user = current_user

    if recipe.save
      flash[:success] = 'New Recipe was successfully added.'
      redirect_to recipes_path
    else
      flash[:danger] = 'New Recipe adding Failed. Please try again.'
    end
  end

  def new
    @recipe = Recipe.new
  end

  def destroy
    recipe = Recipe.find(params[:id])
    if current_user == recipe.user
      recipe.destroy
      flash[:success] = 'Recipe was successfully removed.'
    else
      flash[:danger] = 'The selected recipe belongs to another user'
    end
    redirect_to recipes_path
  end

  def public
    @public_recipes = Recipe.includes(:user).where(public: true)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :cooking_time, :preparation_time, :public, :description)
  end
end
