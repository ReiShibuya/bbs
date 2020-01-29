class CommentsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  # 新規コメント投稿
  def create
    @topic = Topic.find(params[:topic_id])
    # @comment = @topic.comments.build(comment_params)
    @comment = @topic.comments.new(comment_params)
    @comment.set_reid(@topic.comments.count + 1)
    # 一番最後のコメントのreidに1を加算した数を代入したいけど「undefined method `+' for nil:NilClass」のエラーが出て上手くいかない
    # 多分lastメソッドがボトルネック
    # どうも「last.reid」を使うとエラーが出る
    # ログを見るとcomment.rbのプライベートメソッドが機能していない？
    # 「@topic.comments.last.reid」がnilの可能性
    # @comment.set_reid(@topic.comments.last.reid + 1)
    # ids = @topic.comments[-1].attributes
    # @comment.set_reid(ids["reid"] + 1)
    if @comment.save
      flash[:notice] = 'コメントしました'
    else
      flash[:error] = '名前、本文を入力してください'
    end
    redirect_to topic_path(@topic)
  end

  # 消去(createアクションのlastメソッドの件が上手くいけば復活させる)
  # def destroy
  #   @topic = Topic.find(params[:topic_id])
  #   @comment = @topic.comments.find(params[:id])
  #   @comment.destroy
  #   flash[:dlt] = 'コメントを消去しました'
  #   redirect_to topic_path(@topic)
  # end

  # 返信先のコメント表示
  def show
    @comment = Comment.find(params[:id])
  end

  # 削除(名前はupdateだけど)
  def update
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.find(params[:id])
    @comment.delete_comment
    @comment.save
    flash[:dlt] = 'コメントを削除しました'
    redirect_to topic_path(@topic)
  end

  # TODO: 管理者ページを作る

  private
    def comment_params
      params.require(:comment).permit(:name, :content)
    end
end
