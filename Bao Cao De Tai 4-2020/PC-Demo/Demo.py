import numpy as np
import time
def showarray(a, fmt='png'):
    a = np.uint8(a)
    f = StringIO()
    PIL.Image.fromarray(a).save(f, fmt)
    IPython.display.display(IPython.display.Image(data=f.getvalue()))
class GF():
    def __init__(self, f):
        Max = np.max(f)
        f2 = np.zeros(Max+1, np.uint8)
        f2[f] = 1
        f = np.flip(f2)
        self.len_of_symbol = Max
        self.q = 2**self.len_of_symbol
        self.table = np.array(self.make_code_table(f))
        
    def sub_matrix(self, A, i, j):
        A1 = np.delete(A, i, 0)
        A2 = np.delete(A1, j, 1)
        return A2

    def det(self, A):
        size = A.shape
        if size[0]==2 and size[1]==2:
            d = self.add(self.multi(A[0, 0],A[1, 1]), self.multi(A[1, 0],A[0, 1]))
            return d
        else:
            d = 0
            for i in range(size[0]):
                d=self.add(self.multi(A[0, i],self.det(self.sub_matrix(A, 0, i))), d)
            return d
        
    def make_code_table(self, f):
        m = len(f)-1
        N = 2**m
        table = ["0"*m]
        x =""
        for i in range(1,m+1):
            if f[i]==0:
                x+="0"
            else:
                x+="1"
        for i in range(0, m):
            c="0"*m
            c = c[0:i] + "1"+c[i+1:]
            c = c[::-1]
            table.append(c)
        for i in range(m+1, N):
            a = table[-1]
            a1 = a[1:]+"0"
            b = "0"*m
            if a[0]=="1":
                b = x
            c = self.add_string_code(a1, b)
            table.append(c)
        return table

    def add_string_code(self, a, b):
        c =""
        for i in range(self.len_of_symbol):
            if a[i]!= b[i] :
                c+="1"
            else:
                c+="0"
        return c
    def add(self, a, b):
        if  np.isscalar(a) and  np.isscalar(b):
            a= int(a)
            b = int(b)
            a1 = self.table[a]
            b1 = self.table[b]
            c1 = self.add_string_code(a1, b1)
            c, = np.where(self.table == c1)
            return c[0]
        elif not np.isscalar(a):
            if np.isscalar(b):
                raise ValueError("a, b must have same shape ( a:",a.shape,", b is scalar)" )
            else:
                a_size = a.shape
                b_size = b.shape
                if  len(a_size) ==2 and  len(a_size)==2:
                    if a_size[0] != b_size[0] or a_size[1] != b_size[1] :
                        raise ValueError("a, b must have same shape ( a:"+ str(a.shape) +",  b:"+str(b.shape)+ ")" )
                    else:
                        c = np.zeros_like(a, np.uint8)
                        for i in range(a_size[0]):
                            for j in range(a_size[1]):
                                c[i, j] = self.add(a[i, j], b[i, j])
                        return c
                elif len(a_size)==1 and len(b_size)==1 and a_size ==b_size :
                    c = np.zeros_like(a, np.uint8)
                    for i in range(a_size[0]):
                        c[i] = self.add(a[i], b[i])
                    return c
                else:
                    raise ValueError("a, b must have same shape ( a:"+ str(a.shape) +",  b:"+str(b.shape)+ ")" )         
    def multi(self, a, b):
        if  np.isscalar(a) and  np.isscalar(b):
                if a ==0 or b == 0:
                    return 0
                else:
                    c = (a+b-2) % (self.q-1)
                    return c+1
        elif not np.isscalar(a):
            a_size = a.shape
            if np.isscalar(b):
                c = [self.multi(i, b) for i in a]
                return np.array(c)
            b_size = b.shape
            if a_size[1] != b_size[0] :
                raise ValueError("Can not multiply 2 matrix of dimension: ", a.shape, b.shape)
            else:
                c = np.zeros((a_size[0], b_size[1]), np.uint8)
                for i in range(a_size[0]):
                    for j in range(b_size[1]):
                        for k in range(a_size[1]):
                            c[i, j] =self.add(c[i, j], self.multi(a[i, k], b[k, j])) 
                return c
    def make_sub_matrix(self, x):
        N =  N = self.q -1
        sub = np.zeros((N, N), np.uint8)
        index = x-1
        for i in range(N):
            sub[i, index] = index+1
            index +=1
            if index ==N:
                index =0
        return sub
    def reserve_e(self, a):
            a2 = self.q+1-a
            if a2 == self.q:
                a2 = 1
            if a2 == self.q+1:
                a2 = 0
            return a2
    def Reserve(self, X, show =False):
        N = X.shape[0]
        def make_I(n):
                In = np.zeros((n, n), np.uint8)
                for i in range(n):
                    In[i, i] =1
                return In
        X1 = make_I(N)
        for i in range(N):
            if show:
                print(i)
            C = make_I(N)
            for j in range(N):
                C[j, i] = self.multi(X[j, i], self.reserve_e(X[i,i]))
            C[i,i] = self.reserve_e(X[i,i])
            X = self.multi(C,X)
            X1 = self.multi(C,X1)
        return X1
    
import numpy as np
from scipy.special import erfc

def S2B(symbol, table):
    b = table[symbol]
    B = np.array(list(b)).astype(np.float32)
    return B

def probB(x, N0):
    d1 = abs(-1-x)
    d2 = abs(1-x)
    p0 = np.e**(-d1/N0)/(np.e**(-d1/N0)+np.e**(-d2/N0))
    p1 = 1-p0
    return [p0, p1]

def probS(S, N0, q, table, M):
    B = np.zeros((q, 2))
    for i in range(q):
        B[i] = probB(S[i], N0)
    P = np.zeros(M)
    for i in range(M):
        Bi = S2B(i, table)
        p = 1
        for j in range(q):
            p *=B[j, int(Bi[j])]
        P[i] = p
    m = np.max(P)
    P = np.log10(m/P)
    P[P>2]=2
    return P

def BPSK(message, M, table, SNRdB):
    Eb = 1
    N0 = Eb/10**(SNRdB/10)
    q = int(np.log2(M))
    Ns = len(message)
    Nb = Ns*q
    noise = np.sqrt(N0/2)*np.random.randn(Nb)
    noise = noise.reshape((Ns, q))
    X = np.zeros_like(noise)
    for i in range(Ns):
        X[i]= S2B(message[i], table)
    X[X==0]=-1
    Y = X+noise
    output = np.zeros((Ns, M))
    for i in range(Ns):
        output[i] = probS(Y[i], N0, q, table, M)
    return output

def HardDicision(Message):
    return np.argmin(Message, axis=1)

def score(X, Y):
    Z = np.zeros_like(X)
    Z[X!=Y]=1
    return np.sum(Z)

def predict(Q):
    message = np.argmin(Q, axis=0)
    X = 0
    for i in range(dc):
        X = gl.add(X, message[i])
    return message, X

def int2bits(x):
    return '{0:08b}'.format(x)

def int2creal(x):
    return '{0:010b}'.format(x)

def byte2int(byte):
    return int(byte, 2)

def split_with_length(bits, length):
    res=[bits[y-length:y] for y in range(length, len(bits)+length,length)]
    return res

def bits2frame(bits):
    bytearrays = split_with_length(bits[:63], 3)
    symbols = [byte2int(s) for s in bytearrays]
    return symbols



gl = GF([3,  1, 0])
print(gl.table)

Scale = 50
dc = 3
q = 8
dtype = np.int16
#dtype = np.float32
G = np.load("G.npy").astype(np.int16)
H = np.load("H.npy").astype(np.int16)
sub = np.load("sub.npy").astype(np.int16)
m = H.shape[0]
n = H.shape[1]
k = n- m
H_non_zeros_index  = np.zeros((m, dc), np.uint16)
for i in range(m):
    stt = 0
    for j in range(n):
        if H[i, j]!=0:
            H_non_zeros_index[i, stt] = j
            stt+=1   
lob = gl.len_of_symbol
def text_to_bits(text, encoding='utf-8', errors='surrogatepass'):
    bits = bin(int.from_bytes(text.encode(encoding, errors), 'big'))[2:]
    return bits.zfill(8 * ((len(bits) + 7) // 8))

def text_from_bits(bits, encoding='utf-8', errors='surrogatepass'):
    result = ""
    bytes_splited = split_with_length(bits, 8)
    for byte in bytes_splited:
        n = int(byte, 2)
        b = "0"
        try:
            b = n.to_bytes((n.bit_length() + 7) // 8, 'big').decode(encoding, errors) or '\0'
        except:
            pass
        result+=b
    return result

def split_with_length(bits, length):
    res=[bits[y-length:y] for y in range(length, len(bits)+length,length)]
    return res

def text_to_frames(text):
    bits = text_to_bits(text)
    l = len(bits)
    l_pad = l if l%(lob*k)==0 else lob*k*(l//(lob*k)+1)
    n_pad = l_pad-l
    bits+="0"*n_pad
    S = split_with_length(bits, lob)
    symbols = [np.where(gl.table==s)[0][0] for s in S]
    num_frame = l_pad//(k*lob)
    frames= np.array(symbols).reshape((num_frame, k))
    return frames, l, num_frame

def bits_to_frames(bits):
    l = len(bits)
    l_pad = l if l%(lob*k)==0 else lob*k*(l//(lob*k)+1)
    n_pad = l_pad-l
    bits+="0"*n_pad
    S = split_with_length(bits, lob)
    symbols = [np.where(gl.table==s)[0][0] for s in S]
    num_frame = l_pad//(k*lob)
    frames= np.array(symbols).reshape((num_frame, k))
    return frames, l, num_frame

def frames_to_text(frames, l):
    symbols = frames.reshape(frames.shape[0]*frames.shape[1])
    S = [gl.table[s] for s in symbols]
    bits = ""
    for s in S:
        bits+=s
    bits = bits[:l]
    text = text_from_bits(bits)
    return text

def frames_to_bits(frames, l):
    symbols = frames.reshape(frames.shape[0]*frames.shape[1])
    S = [gl.table[s] for s in symbols]
    bits = ""
    for s in S:
        bits+=s
    bits = bits[:l]
    return bits

def send(Q):
    cf.ser.write(bytes([15]))
    time.sleep(0.0001)
    Q2 = Q.transpose()
    A =Q2.reshape(n*q)
    B = [int2creal(x) for x in A]
    S=""
    for s in B:
        S+=s
    bytes_arr = split_with_length(S, 8)
    for byte in bytes_arr:
        cf.ser.write(bytes([int(byte, 2)]))
        time.sleep(0.0001)

def send_frame(frame, SNRdB):
    Scale=100
    frame = frame.reshape(k, 1)
    p = gl.multi(G, frame)
    c0 = np.concatenate((frame, p))
    c = np.zeros_like(c0)
    c[sub.astype(np.uint8)] = c0
    c = c.reshape(n)
    Q0 = BPSK(c, q, gl.table, SNRdB)
    Q0 = Q0.transpose()
    Q = (Q0*Scale).astype(np.int16)
    send(Q)
    c2, s = predict(Q)
    c2 = np.array(c2)
    return c2[sub.astype(np.uint8)][:k]
    
def send_message(message, SNRdB):
    frames,l, num_frame = text_to_frames(message)
    cf.l = l
    cf.results = None
    cf.frame_numers = num_frame
    cf.frames = np.zeros((num_frame, k), np.uint8)
    time.sleep(0.1)
    stt = 0
    hard_frame = []
    for frame in frames:
        stt+=1
        c2 = send_frame(frame, SNRdB)
        hard_frame.append(c2)
    hard_frame = np.array(hard_frame)
    hard_results = frames_to_text(hard_frame, l)
    return hard_results
import serial
from serial import Serial
import config as cf
import threading
cf.frame_numers = None
cf.frames = None
cf.l = None
cf.results = None


def Listening():
    print("listening!")
    data=""
    message = ""
    stt=0
    frame_stt= 0
    while cf.RUN:
        res = cf.ser.read()
        if cf.frame_numers is not None:
            data+=int2bits(ord(res))
            stt+=1
            if stt ==8:
                frame = np.array(bits2frame(data)).astype(np.uint8)
                covered= frame[sub.astype(np.uint8)][:k]
                cf.frames[frame_stt]=covered
                frame_stt+=1
                data = ""
                stt = 0
            if frame_stt==cf.frame_numers:
                cf.frames = cf.frames.astype(np.uint8)
                decode_mess = frames_to_text(cf.frames.astype(np.uint8), cf.l)
                cf.frame_numers = None
                cf.frames = None
                cf.l = None
                data=""
                message = ""
                stt=0
                frame_stt= 0
                cf.results = decode_mess
        else:
            time.sleep(0.001)
    print("stoped")

import serial.tools.list_ports
from tkinter import *
from PIL import Image, ImageTk
from tkinter.scrolledtext import ScrolledText
import config as cf
import serial
from serial import Serial

root = Tk()
root.geometry("1080x800")
root.title("NCKH-HVKTQS")
root.iconbitmap('mta.ico')
root.resizable(width=False, height=False)
label = Label( root, text="Demo NB-LDPC decoder", font=("Helvetica", 16) )
label.pack()

ports = serial.tools.list_ports.comports()
cf.list_ports = ["None", "COM2"]


def Refresh_button_click():
    ports = serial.tools.list_ports.comports()
    list_ports = []
    for port, desc, hwid in sorted(ports):
            list_ports.append(port)
    port_menu['menu'].delete(0, 'end')
    var = StringVar(root)
    var.set('')
    for choice in list_ports:
        port_menu['menu'].add_command(label=choice, command= lambda var=choice:variable.set(var))
        
    LOG_text.delete(1.0, END)
    TextArea1.delete(1.0, END)
    TextArea2.delete(1.0, END)
    TextArea3.delete(1.0, END)
    if cf.ser is not None:
        cf.ser.close()

def update_results(hard_results):
    TextArea2.delete(1.0, END)
    TextArea2.insert(END, hard_results)
    while cf.results is None:
        time.sleep(0.01)
    decoded_result = cf.results
    TextArea3.delete(1.0, END)
    TextArea3.insert(END, decoded_result)

def Send_button_click():
    LOG_text.insert(END, "##################################################\n", "log")
    if cf.ser is None:
        LOG_text.insert(END, "Error: No conneted Port \n", "error")
    message = TextArea1.get("1.0", "end-1c")
    LOG_text.insert(END, "Sending message: "+ message +"\n", "log")
    SNRdB=0
    try:
        SNRdB=float(SNRdB_var.get())
        LOG_text.insert(END, "SNRdB: "+ str(SNRdB)+"\n", "log")
    except:
        LOG_text.insert(END, "Error: SNRdB must be a number \n", "error")
        
    if cf.ser is not None and len(message)>0 and SNRdB>0 and SNRdB<10:
        cf.results=None
        hard_results = send_message(message, SNRdB)
        update_results(hard_results)
    else:
        LOG_text.insert(END, "Session failed, please check the parameters!"+"\n", "log")
    
    LOG_text.tag_config('log', foreground='white', font=("Helvetica", 10))
    LOG_text.tag_config('error', foreground='#eb4d4b', font=("Helvetica", 10))
    
def select_port_change( *args):
    port = variable.get()
    LOG_text.insert(END, "Connecting to port "+ port+" \n", "log")
    try:
        cf.ser = Serial(port, 115200, serial.EIGHTBITS, serial.PARITY_NONE, serial.STOPBITS_ONE)
        cf.RUN =True
        listen = threading.Thread(target=Listening)
        listen.start()
        LOG_text.insert(END, "Connected to "+port+"\n", "log")
    except:
        
        LOG_text.insert(END, "Could not open port "+port+"\n", "error")
    LOG_text.tag_config('log', foreground='white', font=("Helvetica", 10))
    LOG_text.tag_config('error', foreground='#eb4d4b', font=("Helvetica", 10))
    
    
#################### OPTION GRAPH#################################

Option_frame = Frame(root, width = 1040,  height =50)
Option_frame.place(x = 20,y = 60)
Option_frame.pack_propagate(0)

label_port = Label( Option_frame, text="Port Connection:", font=("Helvetica", 12) )
label_port.pack(side = LEFT, pady=5)

variable = StringVar(Option_frame)
variable.set("None") # default value
variable.trace('w', select_port_change)
port_menu = OptionMenu(Option_frame, variable, *(cf.list_ports))
port_menu.pack(side = LEFT, pady=5, padx = 20)

Refresh_button = Button(Option_frame, text ="Refresh", command =Refresh_button_click)
Refresh_button.pack(side = LEFT, pady=5, padx = 5)

label_Noise = Label( Option_frame, text="SNRdB:", font=("Helvetica", 12) )
label_Noise.pack(side = LEFT, pady=5, padx = 20)
SNRdB_var = StringVar()
E = Entry(Option_frame, textvariable=SNRdB_var)
E.pack(side = LEFT, pady=5)

Send_button = Button(Option_frame, text ="Send", command=Send_button_click)
Send_button.pack(side = LEFT, pady=5, padx = 20)


#################### SIMULINK GRAPH#################################

H = 539
W = 1040
Graph_frame = Frame(root, width = W,  height =H)
Graph_frame.place(x = 20,y = 120)
Graph_frame.pack_propagate(0)
canvas = Canvas(Graph_frame, width=W, height=H)
canvas.pack()
img = ImageTk.PhotoImage(Image.open("bg.png").resize((W, H), Image.ANTIALIAS))
#canvas.background = img  # Keep a reference in case this code is put in a function.
bg = canvas.create_image(0, 0, anchor=NW, image=img)

input_frame = Frame(Graph_frame, width = 280,  height =80)
input_frame.place(x = 45, y = 82)
input_frame.propagate(0)

label_message = Label( input_frame, text="Message", font=("Helvetica", 12) )
label_message.pack(side = LEFT, pady=5, padx = 0, fill=Y)

TextArea1 = Text(input_frame, font=("Helvetica", 12))
TextArea1.pack(expand=YES, fill=BOTH)

hard_frame = Frame(Graph_frame, width = 280,  height =80)
hard_frame.place(x = 48, y = 220)
hard_frame.pack_propagate(0)

label_message2 = Label( hard_frame, text="Original", font=("Helvetica", 12) )
label_message2.pack(side = LEFT, pady=5, padx = 0, fill=Y)

TextArea2 = Text(hard_frame, font=("Helvetica", 12))
TextArea2.pack(expand=YES, fill=BOTH)

soft_frame = Frame(Graph_frame, width = 280,  height =80)
soft_frame.place(x = 48, y = 385)
soft_frame.pack_propagate(0)

label_message2 = Label( soft_frame, text="Decoded", font=("Helvetica", 12) )
label_message2.pack(side = LEFT, pady=5, padx = 0, fill=Y)

TextArea3 = Text(soft_frame, font=("Helvetica", 12))
TextArea3.pack(expand=YES, fill=BOTH)

#################### LOG GRAPH#################################

LOG_frame = Frame(root, width = 1040,  height = 100)
LOG_frame.place(x = 20,y = 680)
LOG_frame.pack_propagate(0)

LOG_text = ScrolledText(LOG_frame, background='#40407a')
LOG_text.pack(expand=YES, fill=BOTH)

root.mainloop()