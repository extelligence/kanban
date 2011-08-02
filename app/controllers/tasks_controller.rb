# -*- coding: utf-8 -*-
class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @toDoTasks  = Task.find(:all, :conditions => ["status=?", "todo"],  :order => "priority desc, updated_at desc")
    @doingTasks = Task.find(:all, :conditions => ["status=?", "doing"], :order => "updated_at desc")
    @doneTasks  = Task.find(:all, :conditions => ["status=?", "done"],  :order => "updated_at desc")

    @form_action = 'add_task'
    @form_button = 'タスクを追加する'
    @task = Task.new
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])

    @form_action = 'update'
    @form_button = 'タスクを編集する'

    #content属性に<br/>が含まれていた場合に"\n"に変換する(textarea表示用)
    @task.content = @task.content.gsub("<br/>", "\n")

    render :update do |page|
      #編集対象のタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}", :duration => 0.4
      #フォームを削除する
      page[:task_form].remove
      #フォームを挿入する
      page.insert_html :top, 'task_form_block', :partial => 'form'
      #編集対象のタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}", :duration => 0.6
    end
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    @task.update_attributes(params[:task])
    #改行が入力されていた場合に<br/>に変換する
    @task.content = @task.content.gsub("\n", "<br/>")
    @task.save

    render :update do |page|
      #_task.rhtml を書き換える
      page.replace "#{@task.id}", :partial => 'task', :object => @task
      #書き換えたタスクにvisual_effectをかける
      page.visual_effect :highlight, "#{@task.id}", :duration => 0.4
      #フォームを追加用に戻すため、いったん削除する
      page[:task_form].remove
      #フォームのアクションを'add_task'にする
      @form_action = 'add_task'
      #ボタン表示文字列を追加用にする
      @form_button = 'タスクを追加する'
      @task.content = ""
      @task.owner = ""
      #フォームを挿入する
      page.insert_html :top, 'task_form_block', :partial => 'form'
    end

    #respond_to do |format|
      #if @task.update_attributes(params[:task])
        #format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        #format.xml  { head :ok }
      #else
        #format.html { render :action => "edit" }
        #format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      #end
    #end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

  # ドラッグアンドドロップ時にタスクのステータスを変更する
  def change_status
    @task = Task.find(params[:id])
    if @task.update_attributes(:status => params[:status])
      render :update do |page|
        page.visual_effect :highlight, "#{params[:id]}", :duration => 0.6
      end
    end
  end

  # タスクを追加するメソッド
  def add_task
    @task = Task.new(params[:task])
    @task.status = 'todo'
    #改行が入力されていた場合に変換する
    @task.content = @task.content.gsub("\n", "")
    @task.save

    render :update do |page|
      #フォームをリセットする
      page.call 'Form.reset', 'task_form'
      #要素'todoCaption'の後ろにタスクを:partialで挿入する
      page.insert_html :top, 'todoCaption', :partial => 'task', :object => @task
      #タスクのdraggableを維持する
      page.draggable "#{@task.id}"
      #追加したタスクにvisual_effectをかける
      page.visual_effect :highlight,"#{@task.id}",:duration => 1
    end
  end
end
