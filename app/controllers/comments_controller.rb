class CommentsController < ApplicationController
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

  # TODO: 管理者ページを作る

  private
    def comment_params
      params.require(:comment).permit(:name, :content)
    end
end
