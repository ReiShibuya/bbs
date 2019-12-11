class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.create(comment_params)
    flash[:notice] = 'コメントしました'
    redirect_to topic_path(@topic)
  end

  # TODO: バリデーションの挙動を追加

  private
    def comment_params
      params.require(:comment).permit(:name, :content)
    end
end
