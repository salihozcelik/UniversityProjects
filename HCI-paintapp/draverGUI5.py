from tkinter import *
import tkinter.font
from tkinter.colorchooser import askcolor



class PaintApp:

    DEFAULT_COLOR = 'black'

    # Stores current drawing tool used
    drawing_tool = "pencil"

    # Tracks whether left mouse is down
    left_but = "up"

    # x and y positions for drawing with pencil
    x_pos, y_pos = None, None

    # Tracks x & y when the mouse is clicked and released
    x1_line_pt, y1_line_pt, x2_line_pt, y2_line_pt = None, None, None, None

    # ---------- CATCH MOUSE UP ----------

    def left_but_down(self, event=None):
        self.left_but = "down"

        # Set x & y when mouse is clicked
        self.x1_line_pt = event.x
        self.y1_line_pt = event.y

    # ---------- CATCH MOUSE UP ----------

    def left_but_up(self, event=None):
        self.left_but = "up"

        # Reset the line
        self.x_pos = None
        self.y_pos = None
        # Set x & y when mouse is released
        self.x2_line_pt = event.x
        self.y2_line_pt = event.y

        # If mouse is released and line tool is selected
        # draw the line
        if self.drawing_tool == "line":
            self.line_draw(event)
        elif self.drawing_tool == "arc":
            self.arc_draw(event)
        elif self.drawing_tool == "oval":
            self.oval_draw(event)
        elif self.drawing_tool == "rectangle":
            self.rectangle_draw(event)
        elif self.drawing_tool == "delete":
            self.delete_line(event)
        elif self.drawing_tool == "Clear":
            self.clearAll(event)
    # ---------- CATCH MOUSE MOVEMENT ----------

    def motion(self, event=None):

        if self.drawing_tool == "pencil":
            self.pencil_draw(event)
        elif self.drawing_tool == "delete":
            self.delete_line(event)

    # ---------- DRAW PENCIL ----------

    def pencil_draw(self, event=None):
        if self.left_but == "down":

            # Make sure x and y have a value
            paint_color = self.color
            if self.x_pos is not None and self.y_pos is not None:
                event.widget.create_line(self.x_pos, self.y_pos, event.x, event.y, fill=paint_color,smooth=TRUE)

            self.x_pos = event.x
            self.y_pos = event.y


    # ---------- DELETE  ----------

    def delete_line(self, event=None):

        if self.left_but == "down":
            paint_color =  "white"
            if self.x_pos is not None and self.y_pos is not None:
                event.widget.create_line(self.x_pos, self.y_pos, event.x, event.y, width = 20, fill=paint_color,smooth=TRUE)


            self.x_pos = event.x
            self.y_pos = event.y

    def clearAll(self, event=None):
        event.widget.delete("all")

    # ---------- DRAW LINE ----------

    def line_draw(self, event=None):

        paint_color =  self.color

        if None not in (self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt):
            event.widget.create_line(self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt, smooth=TRUE, fill=paint_color)

    # ---------- DRAW ARC ----------

    def arc_draw(self, event=None):

        paint_color = self.color

        if None not in (self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt):

            coords = self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt
            event.widget.create_arc(coords, start=0, extent=150,
                                    style=ARC,fill=paint_color)

    # ---------- DRAW OVAL ----------

    def oval_draw(self, event=None):

        paint_color = self.color

        if None not in (self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt):

            event.widget.create_oval(self.x1_line_pt, self.y1_line_pt,  self.x2_line_pt, self.y2_line_pt,
                                        outline=paint_color,
                                        width=2)

    # ---------- DRAW RECTANGLE ----------

    def rectangle_draw(self, event=None):

        paint_color = self.color

        if None not in (self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt):

            event.widget.create_rectangle(self.x1_line_pt, self.y1_line_pt, self.x2_line_pt, self.y2_line_pt,
                outline=paint_color,
                width=2)




    def __init__(self, root):
        drawing_area = Canvas(root,width=800, height=600, bg="white")
        drawing_area.pack(expand=True)
        self.color = self.DEFAULT_COLOR

        drawing_area.bind("<Motion>", self.motion)
        drawing_area.bind("<ButtonPress-1>", self.left_but_down)
        drawing_area.bind("<ButtonRelease-1>", self.left_but_up)
        a = Button(root, text='color', command=self.choose_color, bg='white').pack(side=LEFT)
        a = Button(root, text='pencil', command=self.pencil, bg='white').pack(side=LEFT)
        a = Button(root, text='arc', command=self.arctool, bg='green').pack(side=LEFT)
        a = Button(root, text='rectangle', command=self.recttool, bg='red').pack(side=LEFT)
        a = Button(root, text='line', command=self.linetool, bg='blue').pack(side=LEFT)
        a = Button(root, text='oval', command=self.ovaltool, bg='yellow').pack(side=LEFT)
        a = Button(root, text='delete', command=self.deleteTool, bg='gray').pack(side=LEFT)
        a = Button(root, text='Clear', command=self.clear_all, bg='gray').pack(side=LEFT)
    #---------Tool----------------------
    def arctool(self):
        self.drawing_tool = "arc"
    def choose_color(self):
        self.eraser_on = False
        self.color = askcolor(color=self.color)[1]

    def recttool(self):
        self.drawing_tool = "rectangle"

    def linetool(self):
        self.drawing_tool = "line"

    def pencil(self):
        self.drawing_tool = "pencil"

    def ovaltool(self):
        self.drawing_tool = "oval"

    def deleteTool(self):
        self.drawing_tool = "delete"

    def clear_all(self):
        self.drawing_tool = "Clear"

root = Tk()

paint_app = PaintApp(root)

root.mainloop()