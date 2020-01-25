class TopicsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  def index
    # Topicに付いた一番最後のcommentの日付(created_atかupdated_at)の新しい順で並び替えたい
    # ↑の原理はTopicにそれぞれ対応しているCommentを全て取り出しupdated_atを降順で並び替えている
    # 全て取り出すのは効率的じゃなさそうなのでgroup(:topic_id)で最新のComment以外を除外
    @topics = Topic.includes(:comments).order("comments.updated_at DESC").group(:topic_id).paginate(page: params[:page], per_page: 5)
    # TODO: groupというメソッドがよくわからんので後で調べる
    # どうもgroupを使うとDB側でユニーク化しているらしい
    # 全Topicが最後に付いたCommentの降順で並んでいるのは副作用かもしれない
    # あるいは降順で並び替えたCommentの一番上のupdated_atで判断を下しているかも
  end

  def create
    @topic = Topic.new(topic_params)
    # スレたてと同時にコメントも投稿させる、もうちょい改良できそう
    # @comment = @topic.comments.build(comment_params)
    @comment = @topic.comments.new(comment_params)
    @comment.set_bolongs_id(1)
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
    # 全コメントを@commentsに格納したのは件のid表示において色々スッキリさせたかった
    # @comments = @topic.comments.paginate(page: params[:page], per_page: 5)
    paging = @topic.comments
    @comments = paging.paginate(page: params[:page], per_page: 5)
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
