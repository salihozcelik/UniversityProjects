import tkinter
class Paint:
    def redraw(self):
        if(len(self.corde)):
            for i in range(len(self.corde)):
                print(self.cords, self.corde)
                self.canvas_file.create_line(self.cords[i],self.corde[i],width=4, fill="black")
        if (len(self.ocorde)):
            for i in range(len(self.ocorde)):
                print(self.ocords, self.ocorde)
                self.canvas_file.create_oval(self.ocords[i], self.ocorde[i], width=4, outline="black")

    def button_released(self,event):
        self.x.extend([self.current_x,self.current_y])
        self.y.extend([event.x,event.y])
        if(self.t=="l"):
            self.cords.append(self.x)
            self.corde.append(self.y)
        elif(self.t=="c"):
            self.ocords.append(self.x)
            self.ocorde.append(self.y)
        self.exist=1
        print(self.cords,self.corde)
        self.current_x, self.current_y,self.n,self.oldx,self.oldy,self.x,self.y,self.t=0,0,0,0,0,list(),list(),""
    def button_click(self,event):
            self.canvas_file.create_oval(event.x,event.y,event.x,event.y,fill="black",width=4)
    def line_click(self,event):
        self.canvas_file.delete("all")
        if(self.exist==1):
            self.redraw()
        if(self.n==0):
            self.current_x, self.current_y = event.x, event.y
            self.n=1
        self.canvas_file.create_line(self.current_x,self.current_y,event.x,event.y,width=4, fill="black")
        self.oldx=event.x
        self.oldy=event.y
        self.t="l"
        self.canvas_file.bind("<ButtonRelease-1>",self.button_released)
    def clear_screen(self):
        self.canvas_file.delete("all")
        self.current_x, self.current_y,self.n,self.oldx,self.oldy,self.x,self.y,self.t=0,0,0,0,0,list(),list(),""
        self.ocords,self.ocorde,self.corde,self.cords=list(),list(),list(),list()
    def create_circle(self,event):
        self.canvas_file.delete("all")
        if(self.exist==1):
            self.redraw()
        if(self.n==0):
            self.current_x, self.current_y = event.x, event.y
            self.n=1
        self.canvas_file.create_oval(self.current_x,self.current_y,event.x,event.y,width=4, outline="black")
        self.oldx=event.x
        self.oldy=event.y
        self.t="c"
        self.canvas_file.bind("<ButtonRelease-1>",self.button_released)
    def create_rectangle(self,event):
        self.canvas_file.delete("all")
        if(self.exist==1):
            self.redraw()
        if(self.n==0):
            self.current_x, self.current_y = event.x, event.y
            self.n=1
        self.canvas_file.create_rectangle(self.current_x,self.current_y,event.x,event.y,width=4, outline="black")
        self.oldx=event.x
        self.oldy=event.y
        self.t="c"
        self.canvas_file.bind("<ButtonRelease-1>",self.button_released)

    def pen_selected(self):
        self.canvas_file.bind("<B1-Motion>",self.button_click)
    def line_selected(self):
        self.canvas_file.bind("<B1-Motion>",self.line_click)
    def circle_selected(self):
        self.canvas_file.bind("<B1-Motion>",self.create_circle)

    def rectangle_selected(self):
        self.canvas_file.bind("<B1-Motion>",self.create_rectangle)

    def __init__(self):
        main_window=tkinter.Tk()
        self.x, self.y = list(),list()
        self.current_y,self.current_x,self.n=0,0,0
        self.exist = 0
        self.cords,self.corde,self.ocords,self.ocorde=list(),list(),list(),list()
        self.oldx,self.oldy,self.t=0,0,""
        frame1=tkinter.Frame(main_window)
        frame1.pack(side=tkinter.LEFT)
        top_left_frame1=tkinter.Frame(frame1)
        top_left_frame1.pack(side=tkinter.TOP)
        top_left_frame2 = tkinter.Frame(frame1)
        top_left_frame2.pack(side=tkinter.TOP)
        top_left_frame3 = tkinter.Frame(frame1)
        top_left_frame3.pack(side=tkinter.TOP)
        botton_left_frame=tkinter.Frame(frame1)
        botton_left_frame.pack(side=tkinter.BOTTOM)
        frame2=tkinter.Frame(main_window)
        frame2.pack(side=tkinter.TOP)
        main_window.geometry("500x500")
        pen=tkinter.Button(top_left_frame1,text="PEN",command=self.pen_selected)
        pen.pack(side=tkinter.LEFT)
        clear_button=tkinter.Button(top_left_frame2,text=" Clear All", command=self.clear_screen)
        clear_button.pack(side=tkinter.TOP)
        circle_button=tkinter.Button(top_left_frame3,text=" Draw Circle O ",command=self.circle_selected)
        clear_button.pack(side=tkinter.TOP)
        rectangle_button=tkinter.Button(top_left_frame3,text=" Draw Rectangle ",command=self.rectangle_selected)
        rectangle_button.pack(side=tkinter.TOP)
        self.line=tkinter.Button(botton_left_frame,text=" Draw Line  /   ",command=self.line_selected)
        self.line.pack(side=tkinter.RIGHT)
        self.canvas_file=tkinter.Canvas(frame2,width=1600,height=1600,background="white")
        self.canvas_file.pack()
        main_window.mainloop()

p=Paint()