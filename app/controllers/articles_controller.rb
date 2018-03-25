class ArticlesController < ApplicationController

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save

        # 画像のアップロード対応
        if params[:images]
          params[:images].each { |image|
            @article.pictures.create(image: image)
          }
        end

        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end

      def article_params
        params.require(:article).permit(:title, :description, :pictures)
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)

        # 画像のアップロード対応
        if params[:images]

          # 前回登録してある画像は全て削除
          Article.find(params[:id]).pictures.each do |image|
            image.destroy
          end

          # 代わりに今回アップする画像に差し替え
          params[:images].each { |image|
            @article.pictures.create(image: image)
          }
        end

        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
