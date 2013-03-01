#define MAMPACKAGESIZE 4*1024
#define PARMBITS 	256
#define BITSPERBYTE	8

	unsigned int 	RequestType;			// ���ױ��룬4�ֽ�
	unsigned char firstflag;				// �Ƿ��һ�������װ�����
	unsigned char nextflag;				// �Ƿ����������
	unsigned int recCount;				// �����ļ�¼��
	unsigned int  retCode;				// ���ش���
	unsigned int  UserID;				// �����ߵ�ID����
	ST_ADDR		  addr;			// �����ŵĵ�ַ��6���ӽڣ�
	unsigned char ParmBits[PARMBITS/BITSPERBYTE];

	���У���Ҫ����RequestType��ParmBits�������ֶΡ�

	����ṹ���£�

typedef struct st_pack
{
	char			gddm[16];			// BIT 0  BYTE 0 �ɶ�����
	char			ddbz[2];			// BIT 1  BYTE 0 �г���־
	char			nbbm[13];			// BIT 2  BYTE 0 �ڲ�����
	char			card[26];			// BIT 3  BYTE 0 ���뿨
	char			sfzh[51];			// BIT 4  BYTE 0 ���֤
	char			gdxm[21];			// BIT 5  BYTE 0 �ɶ�����
	char			gpdm[11];			// BIT 6  BYTE 0 ��Ʊ����
	char			gpmc[21];			// BIT 7  BYTE 0 ��Ʊ����

	char			gydm[5];			// BIT 0  BYTE 1 ��Ա����
	char			gydm2[5];			// BIT 1  BYTE 1 ��Ա����2(���˹�Ա)
	double			wtjg;				// BIT 2  BYTE 1 ί�м۸�
	double			cjjg;				// BIT 3  BYTE 1 �ɽ��۸�
	long			wtsl;				  // BIT 4  BYTE 1 ί������
	long			cjsl;				  // BIT 5  BYTE 1 �ɽ�����
	char			wtlb[2];			// BIT 6  BYTE 1 ί�����
	char			lbmc[20];			// BIT 7  BYTE 1 ί�����(����)

	char			lxdz[61];			// BIT 0  BYTE 2 ��ϵ��ַ
	char			lxdh[41];			// BIT 1  BYTE 2 ��ϵ�绰
	int				yybid;				// BIT 2  BYTE 2 Ӫҵ�����
	int				yybid1;				// BIT 3  BYTE 2 Ӫҵ�����2(����)
	char			htxh[7];			// BIT 4  BYTE 2 ��ͬ����
	char			wtrq[15];			// BIT 5  BYTE 2 ί������
	char			cjrq[15];			// BIT 6  BYTE 2 �ɽ�����
	unsigned char	jymm[16];			// BIT 7  BYTE 2 ��������

	unsigned char	zjmm[16];			// BIT 0  BYTE 3 �ʽ�����
	unsigned char	czmm[16];			// BIT 1  BYTE 3 ��������
	char			yhdm[5];			// BIT 2  BYTE 3 ���д���
	char			zhlb[2];			// BIT 3  BYTE 3 �˻����
	char			yhzh[41];			// BIT 4  BYTE 3 �����˺�
	double			zzje;				// BIT 5  BYTE 3 ת�˽��
	char			zzlb[2];			// BIT 6  BYTE 3 ת�����
	double			kyje;				// BIT 7  BYTE 3 �����ʽ�

	double			dqje;				// BIT 0  BYTE 4 ��ǰ�ʽ�
	double			zjfs;				// BIT 1  BYTE 4 �ʽ���
	double			wtdj;				// BIT 2  BYTE 4 ί�ж���
	double			rgdj;				// BIT 3  BYTE 4 �˹�����
	double			qtdj;				// BIT 4  BYTE 4 ��������
	long			gpky;				  // BIT 5  BYTE 4 ��Ʊ����
	long			gpye;				  // BIT 6  BYTE 4 ��Ʊ���
	long			gpwtdj;				// BIT 7  BYTE 4 ��Ʊί�ж���
	
	long			gprgdj;				// BIT 0  BYTE 5 ��Ʊ�˹�����
	char			fssj[11];			// BIT 1  BYTE 5 ����ʱ��
	char			zy[4];				// BIT 2  BYTE 5 ժҪ
	char			zymc[21];			// BIT 3  BYTE 5 ժҪ����
	char			gddm2[16];			// BIT 4  BYTE 5 �ɶ�����
	char			ddbz2[2];			// BIT 5  BYTE 5 �г���־
	char			nbbm2[13];			// BIT 6  BYTE 5 �ڲ�����
	char			card2[26];			// BIT 7  BYTE 5 ���뿨
	
	char			sfzh2[41];			// BIT 0  BYTE 6 ���֤
	char			gdxm2[21];			// BIT 1  BYTE 6 �ɶ�����
	unsigned char	lmess;				// BIT 2  BYTE 6 MESS �ĳ���
	char			mess[256];			// Bit 3 - 7 not used

	unsigned char	newmm[16];	// BIT 0  BYTE 7 ������
	char			cxksrq[9];			// BIT 1  BYTE 7 ��ѯ��ʼ����
	char			cxjsrq[9];			// BIT 2  BYTE 7 ��ѯ��������
	int				khlb;				    // BIT 3  BYTE 7 �ͻ����
	char			wtfs[10];			  // BIT 4  BYTE 7 ί�з�ʽ
	char			gdzt[2];			  // BIT 5  BYTE 7 �ɶ�״̬
	char			szdm[10];			  // BIT 6  BYTE 7 ���ڴ���
	char			shdm[10];			  // BIT 7  BYTE 7 �Ϻ�����

	char			szbdm[10];			// BIT 0  BYTE 8 ����B����
	char			shbdm[10];			// BIT 1  BYTE 8 �Ϻ�B����
	char			othdm0[10];			// BIT 2  BYTE 8 ����������
	char			othdm1[10];			// BIT 3  BYTE 8 ���ķ�����
	char			othdm2[10];			// BIT 4  BYTE 8 ���巽����
	long			gpmrcj;				  // BIT 5  BYTE 8 ��Ʊ����ɽ�
	char			email[31];			// BIT 6  BYTE 8 EMAIL��ַ
	char			email2[31];			// BIT 7 BYTE 8 EMAIL��ַ2

	long			bl1;				// BIT 0 BYTE 9 ��1��
	long			bl2;				// BIT 1 BYTE 9 ��2��
	long			bl3;				// BIT 2 BYTE 9 ��3��;
	long			bl4;				// BIT 3 BYTE 9 ��4��;
	long			sl1;				// BIT 4 BYTE 9 ��1��;
	long			sl2;				// BIT 5 BYTE 9 ��2��;
	long			sl3;				// BIT 6 BYTE 9 ��3��;
	long			sl4;				// BIT 7 BYTE 9 ��4��;

	double			bd1;				// BIT 0 BYTE 10 ��1��;
	double			bd2;				// BIT 1 BYTE 10 ��2��;
	double			bd3;				// BIT 2 BYTE 10 ��3��;
	double			bd4;				// BIT 3 BYTE 10 ��4��;
	double			sd1;				// BIT 4 BYTE 10 ��1��;
	double			sd2;				// BIT 5 BYTE 10 ��2��;
	double			sd3;				// BIT 6 BYTE 10 ��3��;
	double			sd4;				// BIT 7 BYTE 10 ��4��;
}ST_PACK;
