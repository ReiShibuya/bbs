class TopicsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  def index
    # Topicに付いた一番最後のcommentの日付(created_atかupdated_at)の新しい順で並び替えたい
    @topics = Topic.includes(:comments).order("comments.updated_at DESC")
    # TODO: 何故Topicを最後に付いたコメントが新しい順に並べて表示することができたか解明すること
    # ↑の原理はTopicにそれぞれ対応しているCommentを全て取り出しupdated_atを降順で並び替えている
    # 全Topicが最後に付いたCommentの降順で並んでいるのは副作用かもしれない
    # あるいは降順で並び替えたCommentの一番上のupdated_atで判断を下しているかも
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
      params.require(:topic).permit(:name, :content)
    end
end
