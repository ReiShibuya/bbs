class CommentsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  def create
    @topic = Topic.find(params[:topic_id])
    # @comment = @topic.comments.build(comment_params)
    @comment = @topic.comments.new(comment_params)
    @comment.set_reid(@topic.comments.count + 1)
    if @comment.save
      flash[:notice] = 'コメントしました'
    else
      flash[:error] = '名前、本文を入力してください'
    end
    redirect_to topic_path(@topic)
  end

  # TODO: コメントの削除は削除したコメントに「このコメントは削除されました。」の本文が表示されるようにしたい
  def destroy
    @topic = Topic.find(params[:topic_id])
    # @comment = Comment.find(params[:id])
    @comment = @topic.comments.find(params[:id])
    @comment.destroy
    flash[:dlt] = 'コメントを削除しました'
    redirect_to topic_path(@topic)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  # TODO: 管理者ページを作る

  private
    def comment_params
      # HACK: コメント欄の名前が未入力の場合はデフォルトネームを入れるようにする(名無しさん)
      params.require(:comment).permit(:name, :content)
    end
end
