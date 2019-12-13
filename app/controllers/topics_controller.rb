class TopicsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  def index
    @topics = Topic.all
  end

  def create
    @topic = Topic.new(topic_params)
    # スレたてと同時にコメントも投稿させる、もうちょい改良できそう
    @comment = @topic.comments.build(comment_params)
    if @topic.save && @comment.save
      flash[:notice] = '新しいスレッドを立てました'
      redirect_to @topic
    else
      flash[:error] = "タイトル、名前、本文は必ず入力してください"
      redirect_to topics_path
    end
  end

  # TODO: 管理者用ログインページを作る
  # TODO: 管理者はスレッドの削除(編集はいらないかも知れないけど一応)できるようにさせる

  def show
    @topic = Topic.find(params[:id])
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:dlt] = '掲示板を削除しました'
    redirect_to topics_path
  end

  private
    def topic_params
      params.require(:topic).permit(:title)
    end

    def comment_params
      # TODO: コメント欄の名前が未入力の場合はデフォルトネームを入れるようにする(名無しさん)
      params.require(:topic).permit(:name, :content)
    end
end
