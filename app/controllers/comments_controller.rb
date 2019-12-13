class CommentsController < ApplicationController
  # http_basic_authenticate_with name: "ddh", password: "secret", only: :destroy

  def create
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.build(comment_params)
    if @comment.save
      flash[:notice] = 'コメントしました'
    else
      flash[:error] = '名前、本文を入力してください'
    end
    redirect_to topic_path(@topic)
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:delete] = 'コメントを削除しました'
    redirect_to topic_path(@topic)
  end

  # TODO: 管理者ページを作る

  private
    def comment_params
      # TODO: コメント欄の名前が未入力の場合はデフォルトネームを入れるようにする(名無しさん)
      params.require(:comment).permit(:name, :content)
    end
end
