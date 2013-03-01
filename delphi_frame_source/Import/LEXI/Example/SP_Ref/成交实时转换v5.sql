use ZTSP
if exists(select * from sysobjects where id=object_id('dbo.jy_cjsszh') and  (0xf & sysstat= 4) )
	drop proc dbo.jy_cjsszh
GO
/*
TODO:
	����/ʱ�� char=>int ��ת��
	ת�й�,���,ת��,���۵Ĵ���
	ָ�����׵Ĵ���
*/
create proc dbo.jy_cjsszh 
	@iyybdm char(8),	/*Ӫҵ������*/
	@iscdm char(1),		/*�г�����*/
	@igddm char(15),	/*�ɶ�����*/
	@icjrq char(8),		/*�ɽ�����*/
	@icjbh char(12),	/*�ɽ����*/
	@ixwdm char(8), 	/*ϯλ����*/
	@iscye int, 		/*�ϴ����*/
	@icjsl int,		/*�ɽ�����*/
	@ibcye int,		/*�������*/
	@izqdm char(8),		/*֤ȯ����*/
	@isbsj char(8),		/*�걨ʱ��*/
	@icjsj char(8),		/*�ɽ�ʱ��*/
	@icjjg money,		/*�ɽ��۸�*/
	@icjje money,		/*�ɽ����*/
	@ihth char(10),		/*��ͬ��*/
	@ijgrq char(8),		/*��������*/
	@ibs char(1),		/*������־ 1 �� 2 �� */  
	@ibz char(3),		/**/
	@izgdm char(3)		/**/
as
begin
 -- ��������ί�лر��������  	
  declare @_wtxh int,  	@_scdm char(1),	@_sbry smallint ,@_sbsj int ,@_sbxh char(10) ,
  	@_cjsl int, 	@_zhsl int,  	@_cjjg money,  	@_cjje money,  	@_yxrq int ,
  	@_xwdm char(8) ,@_rq int ,  	@_cdsqsj int , 	@_cdcgsj int , 	@_cdqqry smallint ,
  	@_cdry smallint ,@_wtzt char(1) ,@_err char(6) ,@_cjsj int ,  	@_wtsl int ,
  	@_cjbs int ,  	@_fy1 money ,  	@_fy2 money ,  	@_khh int ,  	@_sbdm char(15) ,
  	@_gddm char(15) ,@_zqdm char(6) ,@_mmlb char(1) ,@_wtjg money ,	@_djje money
  -- ����ί�лر������(�޸��Ժ��)����   	    	
  declare @new_cjsl int, @new_cjjg money,@new_cjje money,@new_cdcgsj int ,
  	@new_wtzt char(1) ,@new_err char(6) ,@new_cjsj int ,@new_wtsl int ,
  	@new_cjbs int , @new_fy1 money , @new_fy2 money 
  declare @cllr int /* ����ʽ 1 �ɽ� 2 ���� 3 ���� 4 ����*/
  -- ��������֤ȯ�������������  	
  declare @_zqzb char(1), /* ֤ȯ��� */
  @_zqmc char(8), /* ֤ȯ���� */
  @_zqlb char(1),/* ֤ȯ��� */
  @_zjhzbz tinyint ,   /* �ʽ�T��0��ת��־ */
  @_gphzbz tinyint ,   /* ��ƱT��0��ת��־ */
  @_jydw int,	    	/*���׵�λ*/	
  @_zqmz int,             /* ֤ȯ��ֵ */
  @_zjdjfs tinyint ,       /*�ʽ𶳽᷽ʽ */
  @_gpdjfs tinyint ,       /* ��Ʊ���᷽ʽ*/
  @_hbzjjdfx tinyint , /* �ر��ʽ�ⶳ����*/
  @_hbgpjdfx tinyint  /* �ر���Ʊ�ⶳ����*/
  -- �����ʽ��֤ȯ��ʵ���������� 1 �� 2 �� 0 ������
  declare @zqmmfx tinyint,@zjmmfx tinyint
  select @cllr=0
  -- �����ʽ�֤ȯ�仯��
  declare @zjdjjs money, /* �ʽ𶳽����*/
 	@zjjdzj  money, /* �ʽ�ⶳ���� */ 
        @zqdjjs  int, /* ֤ȯ�������*/
        @zqjdzj  int  /* ֤ȯ�ⶳ����*/
	
  -- ������������
  declare @fy1 money,/* ��ĿǰΪֹ����ͨ���� */ @fy2 money /* ����������� */ ,
	@qsfy money,@sxf money
  -- ������������
  declare @ywh int,  /* ҵ��� */	
	@hbdm	char(1), /* ���Ҵ��� */
	@today  int,
	@now	int,
	@khlb   char(1), /* �ͻ���� */
	@glzkhh int,
	@clbz   smallint /* �����־ */
  select @clbz=0	
  -- 0 ����������Ļ�����֤
  -- a) ��֤�ɽ�������ϵͳ����
  exec com_getrqsj null,@today output,@now output
  if convert(int,@icjrq)<>@today
  begin	
	select 'N','�ɽ�������ϵͳ���ڲ�һ��'
	return
  end 
  -- b)���ر��Ƿ��Ѵ���(�ڳɽ���ϸ��),ʹ���г����걨���루�ɶ����룩����ͬ�š��ɽ���š���������ƥ��
  if exists(select 1 from ztjyk..khsscjmx (nolock) 
	where scdm=@iscdm and sbdm=@igddm and hth=@ihth and cjbh=@icjbh and bs=@ibs) 
  begin
 	select 'N','�Ѿ������'
 	return
  end 	
  
  -- 1 ���֤ȯ������
  -- a) ��֤ȯ������л�ȡ֤ȯ���
  select @_zqlb=null
  select @_zqlb=zqlb,@_zqzb=zqzb,@_zqmc=zqmc 
  from ztjyk..zqdm (nolock)
  where zqdm=@izqdm and scdm=@iscdm
  
  if @_zqlb is null 
  begin
	select @clbz=-1
    	select 'N','�Ҳ���֤ȯ'
    	goto insertDetailOnly
  end 
 
  -- b) ���֤ȯ������
  select  @_zjhzbz = zjhzbz,@_gphzbz = gphzbz,  @_jydw =jydw, @_zqmz =zqmz,          
  	@_zjdjfs = zjdjfs, @_gpdjfs = gpdjfs, @_hbzjjdfx =hbzjjdfx,@_hbgpjdfx=hbgpjdfx
  from ztjyk..zqlbcs (nolock)
  where zqlb=@_zqlb and scdm=@iscdm

  -- c) ��鲻��������,���Ժ�İ汾����
  if @_zqlb in ('3' /* ��ծ���� */ )  or @_zqlb is null
  begin
	select @clbz=-2
    	select 'X','������'
    	goto insertDetailOnly
  end
  -- d) ��û��Ҵ���	
  select @hbdm=null
  select @hbdm=hbdm
  from ztjyk..sccycs (nolock)
  where scdm=@iscdm
  if @hbdm is null
  begin
	select @clbz=-3
	select 'N','���Ҵ����'
    	goto insertDetailOnly	
  end	
  --e) ����֤ȯ������ȷ���ʽ��֤ȯ��ʵ����������
  -- �ʽ�
  if @_hbzjjdfx=0 --�ر�������ͬ
    select @zjmmfx=@ibs
  else if @_hbzjjdfx=1 --�ر������෴
    select @zjmmfx=3-@ibs
  else if @_hbzjjdfx=2 --ȫ����
    select @zjmmfx=1
  else if @_hbzjjdfx=3 --ȫ�ⶳ
    select @zjmmfx=2	
  else if @_hbzjjdfx=4 --������
    select @zjmmfx=0	
  else 
  begin
	select @clbz=-14
    	select 'N','ϵͳ��������'
    	goto insertDetailOnly
  end
  -- ֤ȯ
  if @_hbgpjdfx=0 --�ر�������ͬ
    select @zqmmfx=@ibs
  else if @_hbgpjdfx=1 --�ر������෴
    select @zqmmfx=3-@ibs
  else if @_hbgpjdfx=2 --ȫ����
    select @zqmmfx=1
  else if @_hbgpjdfx=3 --ȫ�ⶳ
    select @zqmmfx=2	
  else if @_hbgpjdfx=4 --������
    select @zqmmfx=0
  else 
  begin
	select @clbz=-14
    	select 'N','ϵͳ��������'
    	goto insertDetailOnly
  end
  -- 2 ��ί�лر����ж�ί�лر����
 -- a)�������ί�лر��������,����ʼ��ί�лر����������	
  select @_wtxh=null	
  -- ʹ���г����걨���루�ɶ����룩ƥ��
  select @_wtxh = wtxh,@_scdm  = scdm,@_sbry  = sbry,@_sbsj  = sbsj,@_sbxh  = sbxh,
  	@_cjsl  = cjsl,@_zhsl  = zhsl,@_cjjg  = cjjg,@_cjje  = cjje,@_yxrq  = yxrq,
  	@_xwdm  = xwdm,	@_rq = rq,@_wtzt  = wtzt,@_err   = err,	@_cjsj  = cjsj,
  	@_wtsl  = wtsl,	@_cjbs  = cjbs,	@_fy1   = fy1, 	@_fy2   = fy2, 	@_khh   = khh,
  	@_sbdm  = sbdm,	@_gddm  = gddm,	@_zqdm  = zqdm,	@_mmlb  = mmlb,	@_wtjg  = wtjg,
  	@_djje  = djje
  from ztjyk..wthbk
  where sbxh=@ihth and scdm=@iscdm
  
  select @new_cjsl =@_cjsl, @new_cjjg =@_cjjg,@new_cjje =@_cjje,@new_cdcgsj =@_cdcgsj,
  	@new_wtzt =@_wtzt,@new_err =@_err,@new_cjsj =@_cjsj,@new_wtsl =@_wtsl,
  	@new_cjbs =@_cjbs, @new_fy1 =@_fy1, @new_fy2 =@_fy2
  -- b)�����ͬ�Ų�ƥ��
  if (@_wtxh is null) 
  begin
	select @clbz=-4,@_gddm=@igddm
    	select 'N','��ͬ�Ų�ƥ��'
    	goto insertDetailOnly 
  end	
  -- c)�����ͬ��ƥ��,��ʼУ������
  --��ÿͻ��������˺�	
  select @khlb=null
  select @khlb=khlb,@glzkhh=glzkhh from ztjyk..khzl where khh=@_khh
  if (@khlb is null)
  begin
	select @clbz=-5
    	select 'N','�ͻ�������'
	goto insertDetailOnly	
  end
  if (@_sbdm<>@igddm)
  begin
	select @clbz=-6
    	select 'N','�ɶ����벻ƥ��'
    	goto insertDetailOnly
  end 
  if (@_zqdm<>@izqdm)
  begin
	select @clbz=-7
	select 'N','֤ȯ���벻ƥ��'
    	goto insertDetailOnly
  end 
  /************* ����: ָ��������ָ������ *************/
  if (@zjmmfx=0 and @zqmmfx=0)  --�ر��ʽ�ⶳ����ͻر�֤ȯ�ⶳ�����ǲ�����
  begin
	select @zjdjjs=0.00,@zjjdzj=0.00,@zqdjjs=0,@zqjdzj=0
	select @clbz=5,@new_wtzt=7 /* �ɽ� */
	goto StartProcess
  end	
  /********************************/
  --����У������
  if  (@_mmlb not in ('1','2') /* �������������.����*/)
  begin
	select @clbz=-8
	select @cllr=3  -- ����
	goto speicalTreat
  end	
  if  (@_mmlb<>@ibs)
  begin
	select @clbz=-9
	select 'N','��������ƥ��' 
	goto insertDetailOnly
  end
  if (@icjsl>0) and (@icjjg>0) 
  begin
	select @cllr=1  -- �ɽ�
	-- @_mmlb or @zjmmfx?
	if (@_mmlb=1 and @icjjg>@_wtjg) or (@_mmlb=2 and @icjjg<@_wtjg)
  	begin
		select @clbz=-10
 		select 'N','�۸񳬳�ί�з�Χ'
   		goto insertDetailOnly 
  	end
  end  
  else if (@icjsl<0) and (@icjjg=0) 
  begin
	select @cllr=2  -- ����
  end  
  else 
  begin 
	select @clbz=-11
	select @cllr=4  -- ����
	select 'N','�ɽ��۸������Ϊ��'
	goto insertDetailOnly 
  end
  if @cllr=1
  begin
    if (@icjsl+@_cjsl>@_wtsl)
    begin
	select @clbz=-12
	select 'N','�ɽ���������ί������'
	goto insertDetailOnly
    end	
  end 
  else if @cllr=2
  begin
    if (@_wtsl<-@icjsl)
    begin
	select @clbz=-13
	select 'N','������������ί������'
	goto insertDetailOnly
    end
  end

  
  /********** 3 ��ʼ�����ʽ�֤ȯ�仯�� ************/
  select @zjdjjs=0.00,@zjjdzj=0.00,@zqdjjs=0,@zqjdzj=0
  if @cllr=1
  begin
    /*************  a)����ɽ����� ************/
    -- i)�����ۼƳɽ����,�ɽ�����,�ɽ��۸�,�ɽ�����
    select @new_cjje=@_cjje+@icjje,@new_cjsl=@_cjsl+@icjsl,@new_cjbs=@_cjbs+1,@new_cjsj=@icjsj
    if @new_cjsl>0 select @new_cjjg=@new_cjje/@new_cjsl
    -- ii)�������
    select @fy1=0,@fy2=0
    -- ������ͨ����,ʹ���ۼӺ�ĳɽ������ͳɽ����(���ô洢���̵ļ۸�=0,��Ϊָ���˳ɽ����)
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,0 /*Ӷ�� */,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,2 /*������ */,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,3 /*�������*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,4 /*��������1*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@new_cjsl,@new_cjbs,0,@new_cjje,@qsfy output,@sxf output	
    select @fy1=@fy1+@qsfy
    -- ���㱾���������,ʹ�ñ��γɽ������ͳɽ����
    exec ztsp..qs_getdxqsfy @_khh,@iscdm,4 /*ӡ��˰*/,@izqdm,@_zqlb,@_zqmz,@_jydw,@zjmmfx,
	@icjsl,1,0,@icjje,@fy2 output,@sxf output
    -- �趨@new_fy1,new_fy2
    select @new_fy1=@fy1,@new_fy2=@fy2+@_fy2         			
    if @zjmmfx=1 
    begin
	-- iii)�����ʽ���
	if @new_cjsl=@_wtsl
	begin
	-- ȫ���ɽ�,
	--������ļ���ֵ =���ñ�ί�еĳ�ʼ�������� - ���ۼƣ��ɽ���� - ��ͨ���� -���ۼƣ�������á�
	      select @zjdjjs=@_djje-@new_cjje-@new_fy1-@new_fy2
	end 
	/*	else
	begin
	  -- ���ֳɽ�,���ⶳ�ʽ� 
	end */
    end 
    else if @zjmmfx=2 
    begin
	-- iv)�����ʽ���
	if @_zjhzbz=1 
	begin
	  -- ����ʽ�T+0��ת,ȫ���ɽ��벿�ֳɽ��ļ�����ͬ
	  -- �ⶳ������� = ���γɽ���� - �������Σ���ͨ���ã�������ֵ��- �����Σ��������	
          	select @zjjdzj=@icjje - (@new_fy1-@_fy1) - @fy2
	end
    end
    if @zqmmfx=1
    begin
	-- v)����֤ȯ��
	if @_gphzbz=1
	begin
	--���֤ȯT+0��ת
		select @zqjdzj=@icjsl
	end 
    end	
    /*  else if @zqmmfx=2
    begin
	-- vi)����֤ȯ��:��֤ȯ����/�ⶳ����
    end  */
    if @_wtzt not in ('a' /*������ */ ,'b' /* �ѳ���*/)	
	if @new_cjsl=@_wtsl
		select @new_wtzt='7' else --�ѳɽ�  
		select @new_wtzt='6' --���ɽ�
  end 
  else if @cllr=2
  begin
    /*************  b)���������� ************/
    select @new_cdcgsj=@icjsj	
    select @new_wtsl=@_wtsl+@icjsl -- @icjsl<0 !	
    if @zjmmfx=1 
    begin
	-- i)�����ʽ���
	if @new_wtsl=0 
	--��������Ժ���δ�ɽ�����,�Žⶳ���
	--������ļ���ֵ =���ñ�ί�еĳ�ʼ�������� - ���ۼƣ��ɽ���� - ��ͨ���� -���ۼƣ�������á�
		--�ȼ��� select @djjejs = @_djje - @_cjje - @_fy1 - @_fy2
		select @zjdjjs=@_djje-@new_cjje-@new_fy1-@new_fy2
    end 
    /* else if @zjmmfx=2 
    begin
	-- ii)�����ʽ���,���ʽ𶳽�/�ⶳ���� 
    end */
    if @zqmmfx=2
    begin
	-- iii)����֤ȯ��,֤ȯ���������� = ��������
	select @zqdjjs=-@icjsl -- @icjsl<0
    end
    /* else
    begin
	-- iv)����֤ȯ��	,��֤ȯ����/�ⶳ����
    end	*/		
    if 	@new_wtsl=0
	select @new_wtzt='b' else	--�ѳ���
	select @new_wtzt='a' 		--������
  end
  /*********** 4 ��ʼ�޸����ݿ� ****************/
  StartProcess:
  begin transaction cjhb
	declare @Msg char(50)
	select @Msg="ʵʱ�ɽ�ת���ɹ�"
        -- a) �޸�ί�лر���
 	update ztjyk..wthbk
	set   	cjsl=@new_cjsl ,cjjg=@new_cjjg,	cjje=@new_cjje,	cdcgsj=@new_cdcgsj,
  	 	wtzt=@new_wtzt,	err=@new_err, 	cjsj=@new_cjsj, wtsl=@new_wtsl,
  	 	cjbs=@new_cjbs, fy1=@new_fy1, 	fy2=@new_fy2    
  	where wtxh=@_wtxh
	if @@error<>0 goto PROCESS_ERROR
        -- b) �����ʽ�֤ȯ��ʱ����ⶳ��
	if  (@zqdjjs<>0 or @zqjdzj<>0 or abs(@zjdjjs)>0.00001 or abs(@zjjdzj)>0.00001)
 	begin
          if @zjmmfx=1 or @zqmmfx=1
		select @ywh=803 else
		select @ywh=804
	  -- ���� :- ,�ⶳ: +
	  declare @lsh numeric
          exec com_lsh 0,3,@lsh output				
	  insert into ztjyk..zjzqlsdjjd(lsh,ywh,khh,hbdm,scdm,wtxh,wthth,je,zqdm,fssl)
	  values(@lsh,@ywh,@_khh,@hbdm,@iscdm,@_wtxh,@ihth,@zjjdzj-@zjdjjs,@izqdm,@zqjdzj-@zqdjjs)
	end
	if @@error<>0 goto PROCESS_ERROR
	-- c) �޸Ŀͻ��ʽ�� :�ʽ𶳽����,	�ʽ�ⶳ����
        if (abs(@zjdjjs)>0.00001 or abs(@zjjdzj)>0.00001)
	begin
		update  ztjyk..khzj
		set djje=djje-@zjdjjs,jdje=jdje+@zjjdzj
		where 	khh=@_khh and hbdm=@hbdm
	end
	if @@error<>0 goto PROCESS_ERROR
	-- d) �޸Ŀͻ�֤ȯ :֤ȯ�������,֤ȯ�ⶳ����
	if @zqdjjs<>0 or @zqjdzj<>0
	begin
		if @_gpdjfs=0 
		begin
		  -- ����Ʊ
		  declare @mrzj int/* �������������� */,@mczj int /*�������������� */,
			@mrjezj money /*�������������� */ ,@mcjezj money /* ���������������*/ 
		  if @zqmmfx=1
		  	select @mrzj=@icjsl,@mczj=0,@mrjezj=@icjje,@mcjezj=0 else
			select @mrzj=0,@mczj=@icjsl,@mrjezj=0,@mcjezj=@icjje
		  update ztjyk..tgk
		  set	djs=djs-@zqdjjs,jds=jds+@zqjdzj,
			drmrs=drmrs+@mrzj,drmcs=drmcs+@mczj,
			drmrje=drmrje+@mrjezj,drmcje=drmcje+@mcjezj
		  where gddm=@_gddm /* @_gddm���Իر��� */ and scdm=@iscdm and zqdm=@izqdm
		  if @@error<>0 goto PROCESS_ERROR	
		  if @@rowcount=0
		  begin
			-- �޸���֤ȯ
			declare @_gdxm char(10),@_jjrh smallint
			select @clbz=2
			select @_gdxm=xm
			from ztjyk..gddmb
			where	gddm=@_gddm and scdm=@iscdm
			if @@error<>0 goto PROCESS_ERROR	

			select @_jjrh=jjrh
			from	ztjyk..jjrglkh
			where  khh=@_khh
			if @@error<>0 goto PROCESS_ERROR

			insert into ztjyk..tgk(
				gddm, zqdm, scdm, gdxm, khh, glzkhh, sbdm, zqlb, zqzb, kcs, djs, jds, 
				qsdjs,qsjds, cqdjs, bdrq, cccb, drmrs, drmcs, drmrje, drmcje, psrgsl, 
				sz, jjrh,mrwjssl, mcwjssl, dysl, khlb, zqmc)
			values(@_gddm,@izqdm,@iscdm,@_gdxm,@_khh,@glzkhh,@igddm,@_zqlb,@_zqzb,0,-@zqdjjs,@zqjdzj,
				0,0,0,null,null,@mrzj,@mczj,@mrjezj,@mcjezj,0,
				null,@_jjrh,0,0,0,@khlb,@_zqmc)
			if @@error<>0 goto PROCESS_ERROR
			select @msg="�ɹ�����"
		  end	else		
			select @clbz=1
 		end else 
		begin
		  -- ����׼ȯ
		  select @clbz=3			
		  update ztjyk..hgkhdyq
		  set djs=djs-@zqdjjs
		  where khh=@_khh and scdm=@iscdm
		  if @@error<>0 goto PROCESS_ERROR
		end
	end else
	  if @clbz=0 select @clbz=4
	-- e) �����ָ������,�޸Ĺɶ��˺ű�
	if @_zqlb in ('b','c')  
	begin
		declare	@zdbz tinyint
		if @_zqlb='b' --ָ������	
			select @zdbz=1 else 
			select @zdbz=0
		update  ztjyk..gddmb
		set zdbz=@zdbz
		where	gddm=@_gddm and scdm=@iscdm
		if @@error<>0 goto PROCESS_ERROR
		if @@rowcount=0 select @clbz=6
	end
  	-- f) ��ͻ�ʵʱ�ɽ���ϸ������¼
  	insert into ztjyk..khsscjmx(khh,khlb,scdm,gddm,bs,zqdm,zqlb,sbdm,cjrq,cjbh,xwdm,scye,cjsl,sbsj,cjsj,cjjg,cjje,hth,bz,clbz)
  	values(@_khh,@khlb,@iscdm,@_gddm,@ibs,@izqdm,@_zqlb,@igddm,@icjrq,@icjbh,@ixwdm,@iscye,@icjsl,@isbsj,@icjsj,@icjjg,@icjje,@ihth,@ibz,@clbz)
  PROCESS_OVER: 
  if @@error=0           /*sql �ɹ�*/
  begin
	commit transaction cjhb
	select "Y",@Msg
  end
  else	                 /*sql ʧ��*/
  begin
  PROCESS_ERROR:
	rollback transaction cjhb
	select "N","ʵʱ�ɽ�ת��ʧ��"
  end    
  return
  /*******************   ������������    *******************/
speicalTreat:  -- ���⴦��:�������������/���� ת�й�,���,ת��,����
  select   "X","��ʱ������" -- ��ʱ������	
  goto insertDetailOnly
  --return
  /*******************  ����������֤���� ************************/
insertDetailOnly:  --ֻ��ͻ�ʵʱ�ɽ���ϸ������¼,���޸�������
  /* ע��: �걨����=��������Ĺɶ�����(һ��),�ɶ�����=�ر���Ĺɶ�����(һ�����߶���)*/
  insert into ztjyk..khsscjmx(khh,khlb,scdm,gddm,bs,zqdm,zqlb,sbdm,cjrq,cjbh,xwdm,scye,cjsl,sbsj,cjsj,cjjg,cjje,hth,bz,clbz)
  values(@_khh,@khlb,@iscdm,@_gddm,@ibs,@izqdm,@_zqlb,@igddm,@icjrq,@icjbh,@ixwdm,@iscye,@icjsl,@isbsj,@icjsj,@icjjg,@icjje,@ihth,@ibz,@clbz)
  return   
end
GO

/*
*************   test
select * from ztjyk..khll
declare @zll money
select @zll=null
select @zll=zll from ztjyk..khll where khh=1
select @zll

use ztjyk
sp_help wthbk
*/

--select * from ztjyk..wthbk
--select wtzt,zqdm from ztjyk..wthbk
--select * from ztjyk..tgk
--select * from ztjyk..khsscjmx
--select * from ztjyk..wtk


/*
select * from ztjyk..zqlbcs
where zqlb in ('b','c')

update ztjyk..zqlbcs
set hbzjjdfx=4,hbgpjdfx=4
where zqlb in ('b','c')

select khh,gddm,zdbz from  ztjyk..gddmb
where khh=1010000018
*/