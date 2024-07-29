CREATE OR REPLACE 
PACKAGE up_pck IS

--------------------------------------------------------------------
--
-- Nome : up_pck
--
-- Descrizione : Package del modulo UP
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        04/06/2004  UM       Prima versione
--
--------------------------------------------------------------------
	-- Costanti
	NOME_PAR_GG_DURATA_PWD   CONSTANT  VARCHAR2(20)           := 'PAR_GG_DURATA_PWD' ;
	FLAG_S                   CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('FLAG_S');
	FLAG_N 	                 CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('FLAG_N');

	UP_TIPO_DEST_UTENTE       CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('UP_TIPO_DEST_UTENTE');
	UP_TIPO_DEST_PROFILO      CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('UP_TIPO_DEST_PROFILO');
	UP_TIPO_DEST_SITO         CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('UP_TIPO_DEST_SITO');
	UP_TIPO_DEST_TERMINALE    CONSTANT ut_costanti.valore%TYPE := Ut_pck.Leggi_costante('UP_TIPO_DEST_TERMINALE');

	UP_SEVERITA_MESSAGGIO_CONFERMA CONSTANT up_messaggi.severita%TYPE := ut_pck.leggi_costante('UP_SEVERITA_MESSAGGIO_CONFERMA');
	UP_SEVERITA_MESSAGGIO_NOTIFICA CONSTANT up_messaggi.severita%TYPE := ut_pck.leggi_costante('UP_SEVERITA_MESSAGGIO_NOTIFICA');

-- costanti messaggi ------------------------------------------------------------
	MAIL_PRIO_ALTA          VARCHAR2(2 BYTE)                   := ut_pck.leggi_costante('MAIL_PRIO_ALTA');
	MAIL_PRIO_BASSA         VARCHAR2(2 BYTE)                   := ut_pck.leggi_costante('MAIL_PRIO_BASSA');
	MAIL_PRIO_NORMALE       VARCHAR2(2 BYTE)                   := ut_pck.leggi_costante('MAIL_PRIO_NORMALE');
	MAIL_SENDER_NOTIFICHE   VARCHAR2(100 BYTE)                 := ut_pck.leggi_costante('MAIL_SENDER');

	UPPERCASE_PASSWORD VARCHAR2(1 BYTE) := Ut_pck.Leggi_costante('FLAG_N');

--------------------------------------------------------------------------------
-- FRA 09/05/2024 Funzione che verifica se l'utente passato è gestito con una password in formato HASH oppure no
--------------------------------------------------------------------------------
FUNCTION is_utente_hash(
	in_utente IN up_utenti.utente%TYPE
) RETURN VARCHAR2;

--------------------------------------------------------------------------------
-- FRA 09/05/2024 Funzione che verifica se l'utente passato è gestito con una password in formato HASH oppure no
--------------------------------------------------------------------------------
FUNCTION is_uppercase_password
RETURN VARCHAR2;

--------------------------------------------------------------------------------
PROCEDURE verifica_utente (
	pc_utente      IN  up_utenti.utente%TYPE,
	pc_password    IN  VARCHAR2,
	pc_sito        IN  ut_siti.sito%TYPE,
	pc_terminale   IN  VARCHAR2,  --- Se chaiamata da Java Userenv('TERMINAL') restituisce unknown
	pc_applicazione IN up_applicazioni_t.applicazione%TYPE,
	pc_msg         OUT VARCHAR2
);

--------------------------------------------------------------------------------
PROCEDURE cambio_password (
	pc_utente            IN  up_utenti.utente%TYPE,
	pc_password_attuale  IN  up_utenti.password%TYPE,
	pc_nuova_password    IN  up_utenti.password%TYPE,
	pc_conferma_password IN  up_utenti.password%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE inserimento_utente (
	in_utente              IN up_utenti.utente%TYPE,
	in_descrizione         IN up_utenti.descrizione%TYPE,
	in_is_pwd_hash         IN VARCHAR2,
	in_password            IN up_utenti.password%TYPE,
	in_password_conferma   IN up_utenti.password%TYPE,
	in_sito_default        IN up_utenti.sito_default%TYPE,
	in_email               IN up_utenti.email%TYPE,
	in_serial_id           IN up_utenti.serial_id%TYPE,
	in_profilo             IN up_profili_t.profilo%TYPE,
	in_lingua_def          IN up_utenti.lingua_def%TYPE
);
--------------------------------------------------------------------------------
-- modifica_utente
--------------------------------------------------------------------------------
PROCEDURE modifica_utente (
	in_utente              IN up_utenti.utente%TYPE,
	in_descrizione         IN up_utenti.descrizione%TYPE,
	in_sito_default        IN up_utenti.sito_default%TYPE,
	in_email               IN up_utenti.email%TYPE,
	in_serial_id           IN up_utenti.serial_id%TYPE,
	in_data_connessione    IN up_utenti.data_connessione%TYPE,
	in_data_ultima_mod_pwd IN up_utenti.data_ultima_mod_pwd%TYPE,
	in_lingua_def          IN up_utenti.lingua_def%TYPE,
	in_prog_reg            IN NUMBER
);
--------------------------------------------------------------------------------
PROCEDURE disabilita_menu2 (
	in_profilo        IN up_profili_t.profilo%TYPE,
	in_applicazione   IN up_applicazioni_t.applicazione%TYPE
);
--------------------------------------------------------------------------------
PROCEDURE inserimento_profilo (
	in_profilo              IN up_profili_t.profilo%TYPE,
	in_descrizione          IN up_utenti.descrizione%TYPE,
	in_profilo_base         IN up_profili_t.profilo%TYPE,
	in_applicazione         IN up_applicazioni_t.applicazione%TYPE,
	in_f_disabilita_tutto   IN VARCHAR2 DEFAULT FLAG_N
);

--------------------------------------------------------------------------------
PROCEDURE abil_disabil_funzione (
	in_profilo      IN up_profili_d.profilo%TYPE,
	in_applicazione IN up_profili_d.applicazione%TYPE,
	in_funzione     IN up_profili_d.funzione%TYPE,
	in_f_att        IN VARCHAR2,
	in_prog_reg     IN NUMBER
);

--------------------------------------------------------------------------------
PROCEDURE Aggiunta_Funzione(
	in_funzione    up_applicazioni_d.funzione%TYPE,
	in_descrizione up_applicazioni_d.descrizione%TYPE,
	in_profilo     up_profili_t.profilo%TYPE DEFAULT NULL
);

--------------------------------------------------------------------------------
PROCEDURE set_variabili_contesto (
    pc_utente       IN  up_utenti.utente%TYPE,
    pc_sito         IN  ut_siti.sito%TYPE,
    pc_terminale    IN  VARCHAR2,
    pc_applicazione IN  up_applicazioni_t.applicazione%TYPE,
	 pc_lingua       IN  wise40.wi_lingue.lingua%TYPE DEFAULT 'IT'
);

--------------------------------------------------------------------------------
PROCEDURE invia_notifiche(
	in_id_allarme   IN   ut_allarmi.id_allarme%TYPE,
	in_cod_allarme  IN   ut_allarmi.cod_allarme%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE invia_notifiche(
	in_id_allarme     IN ut_allarmi.id_allarme%TYPE,
	in_cod_allarme    IN ut_allarmi.cod_allarme%TYPE,
	in_data_creazione IN ut_allarmi.data_creazione%TYPE,
	in_utente         IN ut_allarmi.utente%TYPE,
	in_msg_allarme    IN ut_allarmi.msg_allarme%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE invia_messaggio(
	in_mittente       IN up_messaggi.mittente%TYPE,
	in_tipo_dest      IN VARCHAR2,
	in_dest           IN VARCHAR2,
	in_oggetto        IN up_messaggi.oggetto%TYPE,
	in_testo          IN up_messaggi.testo%TYPE,
	in_severita       IN up_messaggi.severita%TYPE DEFAULT UP_SEVERITA_MESSAGGIO_NOTIFICA
);

--------------------------------------------------------------------------------
PROCEDURE invia_messaggio(
	in_tipo_dest   IN VARCHAR2,
	in_dest        IN VARCHAR2,
	in_oggetto     IN up_messaggi.oggetto%TYPE,
	in_testo       IN up_messaggi.testo%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE segna_tutti_letti(
	in_param IN VARCHAR2
);

--------------------------------------------------------------------------------
PROCEDURE segna_letto(
	in_progressivo IN up_messaggi.progressivo%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE invia_mail(
	in_tipo_dest IN VARCHAR2,
	in_dest      IN VARCHAR2,
	in_oggetto   IN ut_mail_message.oggetto%TYPE,
	in_messaggio IN ut_mail_message.messaggio%TYPE,
	in_mittente  IN ut_mail_message.mittente%TYPE DEFAULT MAIL_SENDER_NOTIFICHE,
	in_priorita  IN ut_mail_message.priorita%TYPE DEFAULT MAIL_PRIO_NORMALE
);

--------------------------------------------------------------------------------
PROCEDURE invia_mail_allarme(
	in_tipo_dest  IN VARCHAR2,
	in_dest       IN VARCHAR2,
	in_id_allarme IN ut_allarmi.id_allarme%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE invia_mail_allarme (
	in_tipo_dest      IN VARCHAR2,
	in_dest           IN VARCHAR2,
	in_id_allarme     IN ut_allarmi.id_allarme%TYPE,
	in_data_creazione IN ut_allarmi.data_creazione%TYPE,
	in_utente_all     IN ut_allarmi.utente%TYPE,
	in_cod_allarme    IN ut_allarmi.cod_allarme%TYPE,
	in_msg_allarme    IN ut_allarmi.msg_allarme%TYPE
);

PROCEDURE verifica_utente_generale (
	pc_utente       IN  up_utenti.utente%TYPE,
	pc_password     IN  up_utenti.password%TYPE,
	pc_terminale    IN  VARCHAR2,  --- Se chiamata da Java Userenv('TERMINAL') restituisce unknown
	pc_applicazione IN up_applicazioni_t.applicazione%TYPE,
	pc_msg          OUT VARCHAR2
);
PROCEDURE abil_disabil_applicazione (
	in_utente       IN up_utenti_applicazioni.utente%TYPE,
	in_applicazione IN up_utenti_applicazioni.applicazione%TYPE,
	in_f_att        IN VARCHAR2,
	in_prog_reg     IN NUMBER
);

--------------------------------------------------------------------------------
PROCEDURE Elimina_Utente(
	in_utente IN up_utenti.utente%TYPE
);


--------------------------------------------------------------------------------
PROCEDURE salva_context_config(
    pc_utente       IN  up_utenti.utente%TYPE,
    pc_applicazione IN  up_applicazioni_t.applicazione%TYPE,
    pc_config       IN  wise40.wi_config_t.config%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE salva_trace_sessione(
   in_applicazione          IN wise01.ut_trace_sessioni.applicazione%TYPE,
   in_utente                IN wise01.ut_trace_sessioni.utente%TYPE,
   in_utente_sistema        IN wise01.ut_trace_sessioni.utente_sistema%TYPE,
   in_terminale             IN wise01.ut_trace_sessioni.terminale%TYPE,
   in_terminale_2           IN wise01.ut_trace_sessioni.terminale_2%TYPE,
   in_nome_file             IN wise01.ut_trace_sessioni.nome_file%TYPE,
   in_path_file             IN wise01.ut_trace_sessioni.path_file%TYPE,
   in_jvm                   IN wise01.ut_trace_sessioni.jvm%TYPE,
   in_os                    IN wise01.ut_trace_sessioni.os%TYPE
   --in_versione_app          IN wise01.ut_trace_sessioni.versione_app%TYPE DEFAULT 'N.C.',
   --in_versione_std          IN wise01.ut_trace_sessioni.versione_Std%TYPE DEFAULT 'N.C.'
);

--------------------------------------------------------------------------------
PROCEDURE salva_trace_applicazione(
   in_applicazione          IN wise01.ut_trace_sessioni.applicazione%TYPE,
   in_versione_app          IN wise01.ut_trace_sessioni.versione_app%TYPE DEFAULT 'N.C.',
   in_versione_std          IN wise01.ut_trace_sessioni.versione_Std%TYPE DEFAULT 'N.C.',
   in_utente                IN wise01.ut_trace_sessioni.utente%TYPE,
   in_utente_sistema        IN wise01.ut_trace_sessioni.utente_sistema%TYPE,
   in_terminale             IN wise01.ut_trace_sessioni.terminale%TYPE,
   in_terminale_2           IN wise01.ut_trace_sessioni.terminale_2%TYPE,
   in_nome_file             IN wise01.ut_trace_sessioni.nome_file%TYPE,
   in_path_file             IN wise01.ut_trace_sessioni.path_file%TYPE,
   in_jvm                   IN wise01.ut_trace_sessioni.jvm%TYPE,
   in_os                    IN wise01.ut_trace_sessioni.os%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE insert_wi_preferiti (
	in_descrizione   IN wise40.wi_preferiti.descrizione%TYPE,
	in_nome          IN WISE40.wi_preferiti.nome%TYPE,
	in_tipo          IN wise40.wi_preferiti.tipo%TYPE,
	in_nome_padre    IN WISE40.wi_preferiti.nome_padre%TYPE,
	in_wtc           IN WISE40.wi_preferiti.wtc%TYPE,
	in_ordinamento   IN WISE40.wi_preferiti.ordinamento%TYPE
)  ;

--------------------------------------------------------------------------------
PROCEDURE insert_ut_note_promemoria (
	in_utente           IN  WISE01.ut_note_promemoria.utente%TYPE,
	in_progressivo      IN  WISE01.ut_note_promemoria.progressivo%TYPE,
	in_titolo           IN  WISE01.ut_note_promemoria.titolo%TYPE,
	in_testo            IN  WISE01.ut_note_promemoria.testo%TYPE,
	in_tipologia        IN  WISE01.ut_note_promemoria.tipologia%TYPE,
	in_colore           IN  WISE01.ut_note_promemoria.colore%TYPE,
	in_data_promemoria  IN  WISE01.ut_note_promemoria.data_promemoria%TYPE,
	in_applicazione     IN  WISE01.ut_note_promemoria.applicazione%TYPE
)  ;
--------------------------------------------------------------------------------
PROCEDURE delete_wi_preferiti (
	in_nome          IN  WISE40.wi_preferiti.nome%TYPE,
	in_tipo          IN wise40.wi_preferiti.tipo%TYPE
)  ;
--------------------------------------------------------------------------------
PROCEDURE delete_ut_note_promemoria (
	in_applicazione  IN  WISE01.ut_note_promemoria.applicazione%TYPE,
	in_utente        IN  WISE01.ut_note_promemoria.utente%TYPE,
	in_progressivo   IN  WISE01.ut_note_promemoria.progressivo%TYPE
)  ;

--------------------------------------------------------------------------------
PROCEDURE update_wi_preferiti (
	in_descrizione   IN wise40.wi_preferiti.descrizione%TYPE,
	in_nome          IN WISE40.wi_preferiti.nome%TYPE,
	in_tipo          IN wise40.wi_preferiti.tipo%TYPE,
	in_nome_padre    IN WISE40.wi_preferiti.nome_padre%TYPE,
	in_wtc           IN WISE40.wi_preferiti.wtc%TYPE,
	in_ordinamento   IN WISE40.wi_preferiti.ordinamento%TYPE
)  ;

--------------------------------------------------------------------------------
FUNCTION update_ut_note_promemoria (
	in_utente           IN  WISE01.ut_note_promemoria.utente%TYPE,
	in_progressivo      IN  WISE01.ut_note_promemoria.progressivo%TYPE,
	in_titolo           IN  WISE01.ut_note_promemoria.titolo%TYPE,
	in_testo            IN  WISE01.ut_note_promemoria.testo%TYPE,
	in_tipologia        IN  WISE01.ut_note_promemoria.tipologia%TYPE,
	in_colore           IN  WISE01.ut_note_promemoria.colore%TYPE,
	in_data_promemoria  IN  WISE01.ut_note_promemoria.data_promemoria%TYPE,
	in_applicazione     IN  WISE01.ut_note_promemoria.applicazione%TYPE
) RETURN WISE01.ut_note_promemoria.progressivo%TYPE;

--------------------------------------------------------------------------------
PROCEDURE msg_promemoria_giornalieri;

--------------------------------------------------------------------------------
PROCEDURE genera_token_pwd(
	in_utente IN up_utenti.utente%TYPE
);

--------------------------------------------------------------------------------
PROCEDURE cambio_password_hash (
	in_utente                   IN up_utenti.utente%TYPE,
	in_pwd_attuale              IN up_utenti.hash_password%TYPE,
	in_nuova_password           IN up_utenti.hash_password%TYPE,
	in_conferma_nuova_password  IN up_utenti.hash_password%TYPE
) ;
--------------------------------------------------------------------------------
PROCEDURE cambio_password_hash_token(
	in_utente                   IN up_utenti.utente%TYPE,
	in_token                    IN up_token_utente.token%TYPE,
	in_nuova_password           IN up_utenti.hash_password%TYPE,
	in_conferma_nuova_password  IN up_utenti.hash_password%TYPE
) ;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
FUNCTION is_utente_dominio(
	in_utente IN up_utenti.utente%TYPE
) RETURN BOOLEAN;
END up_pck ;
/

CREATE OR REPLACE 
PACKAGE BODY up_pck AS

--------------------------------------------------------------------
--
-- Nome : up_pck
--
-- Descrizione : Package del modulo UP
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        04/06/2004  UM       Prima versione
--
--------------------------------------------------------------------

	LINGUA_IT   CONSTANT wise40.wi_lingue.lingua%TYPE       := Ut_pck.Leggi_costante('LINGUA_IT');
	NLS_ITALIAN CONSTANT wise40.wi_lingue.nls_language%TYPE := Ut_pck.Leggi_costante('NLS_ITALIAN');

--------------------------------------------------------------------------------
PROCEDURE assegna_profilo (
	in_utente IN up_utenti.utente%TYPE,
	in_profilo IN up_profili_t.profilo%TYPE
) IS
	lc_up_profili_d up_profili_d%ROWTYPE;
	log_notes VARCHAR2(1000);
	lc_cr up_profili_d.cr%TYPE;
BEGIN
	INSERT INTO up_profili_utenti (profilo, utente, cr)
	VALUES (in_profilo, in_utente, cr_pck.crea);
EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE, SQLERRM, log_notes);
		RAISE;
END assegna_profilo;

--------------------------------------------------------------------------------
-- FRA 09/05/2024 Funzione che verifica se l'utente passato è gestito con una password in formato HASH oppure no
--------------------------------------------------------------------------------
FUNCTION is_utente_hash(
	in_utente IN up_utenti.utente%TYPE
) RETURN VARCHAR2
IS

	log_notes  ut_allarmi.msg_allarme%TYPE;
	lc_salt    up_utenti.salt%TYPE;

BEGIN

	-- Verifica se è un utente di dominio
	IF is_utente_dominio(in_utente) THEN
		RETURN FLAG_N;
	END IF;

	log_notes := 'SELECT salt FROM up_utenti WHERE utente = '||in_utente;
	SELECT salt
	INTO lc_salt
	FROM up_utenti
	WHERE utente = in_utente;

	-- Se l'attributo SALT è vuoto, la password non è gestita ad HASH
	IF lc_salt IS NULL THEN
		RETURN FLAG_N;
	ELSE
		RETURN FLAG_S;
	END IF;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE, SQLERRM, log_notes);
		RETURN FLAG_N;
END;

-- -----------------------------------------------------------------------------
-- Restituisce TRUE se l'utente è un utente di dominio, non verifica che lo sia
-- veramente, ma solo in base al contenuto della stringa
-- -----------------------------------------------------------------------------
-- RBE 17/06/2024 prima stesura
-- -----------------------------------------------------------------------------
FUNCTION is_utente_dominio(
	in_utente IN up_utenti.utente%TYPE
) RETURN BOOLEAN AS
BEGIN
	RETURN INSTR(in_utente,'\') != 0 OR INSTR(in_utente,'@') != 0;
EXCEPTION
   WHEN OTHERS THEN
      ut_pck.oracle_log(SQLCODE,SQLERRM,in_utente);
      RAISE;
END is_utente_dominio;


--------------------------------------------------------------------------------
-- FRA 09/05/2024 Funzione che verifica se l'utente passato è gestito con una password in formato HASH oppure no
--------------------------------------------------------------------------------
FUNCTION is_uppercase_password
RETURN VARCHAR2
IS

	log_notes  ut_allarmi.msg_allarme%TYPE;

BEGIN

	RETURN UPPERCASE_PASSWORD;

END;

--------------------------------------------------------------------------------
PROCEDURE verifica_utente (
	pc_utente      IN  up_utenti.utente%TYPE,
	pc_password    IN  VARCHAR2,
	pc_sito        IN  ut_siti.sito%TYPE,
	pc_terminale   IN  VARCHAR2,  --- Se chaiamata da Java Userenv('TERMINAL') restituisce unknown
	pc_applicazione IN up_applicazioni_t.applicazione%TYPE,
	pc_msg         OUT VARCHAR2
) IS

  -- Variabili locali
  ln_prog_reg_attuale     NUMBER(9,0);
  ln_nuovo_prog_reg       NUMBER(9,0);
  ld_sysdate              DATE;
  lc_utente               up_utenti.utente%TYPE;
  lc_lingua_def           up_utenti.lingua_def%TYPE;
  lc_password             ut_allarmi.msg_allarme%TYPE;
  lc_password_attuale     ut_allarmi.msg_allarme%TYPE;
  lc_password_sha256      ut_allarmi.msg_allarme%TYPE;
  ld_data_ultima_mod_pwd  up_utenti.data_ultima_mod_pwd%TYPE;
  lc_sito_default      	  up_utenti.sito_default%TYPE;
  lc_sito      	  		  ut_siti.sito%TYPE;
  lc_f_inattivo           VARCHAR2(1);
  ld_data_inattivo        DATE;

  -- Variabili locali utilizzate per gestire i log
  lc_msg         		VARCHAR2(200);
  ln_esito       		INTEGER;
  lc_conto       		NUMBER;

  PAR_GG_DURATA_PWD  ut_parametri_siti.valore%TYPE;
  lr_hash_password up_utenti.hash_password%TYPE;

BEGIN

	ut_pck.INS_LOG('VERSIONE_APP',ut_pck.UT_DEBUG,'versione: %1', am_pck.GET_VERSIONE_APPLICAZIONE());


	IF (pc_applicazione = 'W-Board') THEN
		verifica_utente_generale(pc_utente, pc_password, pc_terminale, pc_applicazione, pc_msg);
		RETURN;
	END IF;

	-- Inizializzazione parametri di uscita
	lc_msg := 'Inizializzazione parametri di uscita' ;
	pc_msg := '' ;

	-- Inizializzazione costanti
	lc_msg := 'Inizializzazione costanti';
	ld_sysdate := SYSDATE;

	-- Estrae dati dell'utente
	BEGIN

		lc_msg := 'SELECT data_ultima_mod_pwd, profilo '||' FROM up_utenti '||' WHERE utente = '||pc_utente;
		SELECT password, data_ultima_mod_pwd, CR_PCK.get_f_inattivo(CR) ,
				 sito_default, lingua_def, CR_PCK.get_prog_reg(CR), hash_password
		INTO lc_password_attuale, ld_data_ultima_mod_pwd, lc_f_inattivo,
			  lc_sito_default, lc_lingua_def, ln_prog_reg_attuale, lr_hash_password
		FROM up_utenti
		WHERE utente = pc_utente ;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			Ut_Pck.raise_log('UTENTE_INESISTENTE', Ut_Pck.UT_INFO, 'Utente %1 non presente in anagrafica', pc_utente);
	END ;

	-- Setto subito la lingua per eventuali messaggi di errore
	Am_pck.set_lingua(lc_lingua_def);
	lc_password := pc_password;
	lc_msg := 'Controllo la password' ;


	--ut_pck.INS_LOG('DEBUG_1',ut_pck.UT_DEBUG,'pwd input: %1', lc_password);
	--ut_pck.INS_LOG('DEBUG_1',ut_pck.UT_DEBUG,'pwd input: %1', lr_hash_password);

	-- RBE 26/01/2024
	-- password con hash
	-- in caso di pwd con hash la password passata è la rappresentazione
	-- esadecimale dell'hash della password
	IF is_utente_hash(pc_utente) = FLAG_S THEN
		IF UPPER(lc_password) != UPPER(RAWTOHEX(lr_hash_password)) THEN
			ut_pck.raise_log('PWD_UTENTE_ERRATA', Ut_Pck.UT_INFO, 'Password errata per l''utente %1', pc_utente);
		END IF ;
	ELSE

		lc_msg := 'SELECT STANDARD_HASH(lc_password_attuale, ''SHA256'') FROM dual';
		SELECT STANDARD_HASH(lc_password_attuale, 'SHA256')
		INTO lc_password_sha256
		FROM dual;

		IF lc_password != lc_password_attuale AND UPPER(lc_password) != UPPER(lc_password_sha256)  THEN
			ut_pck.raise_log('PWD_UTENTE_ERRATA', Ut_Pck.UT_INFO, 'Password errata per l''utente %1', pc_utente);
		END IF;

	END IF;

	-- Controllo abilitazione
	lc_msg := 'Controllo abilitazione' ;
	IF ( lc_f_inattivo = 'S' ) THEN
		Ut_Pck.raise_log('UTENTE_NON_ABILITATO', Ut_Pck.UT_INFO, 'Utente %1 non abilitato.', pc_utente);
	END IF ;

	-- Sito
	lc_sito := NVL( pc_sito, lc_sito_default);
	lc_msg := 'Controllo sito';
	IF ( lc_sito IS NULL ) THEN
		Ut_Pck.raise_log('SITO_NON_DEFINITO', Ut_Pck.UT_INFO, 'Sito non definito per l''utente %1' , pc_utente);
	END IF ;

	-- Estrae dati del sito
	IF lc_sito != '%' THEN
		BEGIN
			lc_msg := 'SELECT f_inattivo, utente_db '||' FROM ut_siti '||' WHERE sito =  '||lc_sito ;
			SELECT CR_PCK.get_f_inattivo(CR), CR_PCK.get_data_inattivo(CR)
			INTO  lc_f_inattivo,	ld_data_inattivo
			FROM  ut_siti
			WHERE sito = lc_sito ;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				Ut_Pck.raise_log('SITO_INESISTENTE', Ut_Pck.UT_INFO, 'Sito %1 non presente in anagrafica.', pc_sito);
		END ;

		-- sito attivo
		lc_msg := 'Controllo sito attivo' ;
		IF ( ( lc_f_inattivo    = 'S' ) AND	( ld_data_inattivo > ld_sysdate ) ) THEN
			Ut_Pck.raise_log('SITO_NON_ATTIVO', Ut_Pck.UT_INFO,'Sito %1 non attivo', lc_sito);
		END IF ;

		-- Estrae associazione utente / sito
		lc_msg := 'SELECT COUNT(*) '||' FROM up_utenti_siti '||' WHERE utente = '||pc_utente ||' AND sito = '||lc_sito;
		SELECT COUNT(*)
		INTO lc_conto
		FROM up_utenti_siti
		WHERE utente = pc_utente
		AND sito = lc_sito;

		IF lc_conto = 0 THEN
			Ut_Pck.raise_log('SITO_NON_ACCESSIBILE', Ut_Pck.UT_INFO,
								  'Sito %1 non accessibile al''utente %2', pc_sito, pc_utente);
		END IF;
	END IF;

	UPDATE up_utenti
	SET data_connessione = SYSDATE
	WHERE utente = pc_utente;

	set_variabili_contesto (pc_utente, lc_sito, pc_terminale, pc_applicazione, lc_lingua_def);

EXCEPTION
  WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END verifica_utente;

--------------------------------------------------------------------------------
--
-- Nome : cambio_password
--
-- Descrizione : Permette il cambio password di un utente
--
-- Versione   Data        Autore   Descrizione
-- 1.0      28/04/2008     EBR     Prima versione
--
--------------------------------------------------------------------------------
PROCEDURE cambio_password (
	pc_utente            IN  up_utenti.utente%TYPE,
	pc_password_attuale  IN  up_utenti.password%TYPE,
	pc_nuova_password    IN  up_utenti.password%TYPE,
	pc_conferma_password IN  up_utenti.password%TYPE
) IS

	lc_pwd_db up_utenti.password%TYPE;
	log_notes  VARCHAR2(1000);

BEGIN

	IF is_utente_hash(pc_utente) = FLAG_S THEN
		-- RBE 26/01/2024
		ut_pck.raise_log('DEPRECATA', ut_pck.UT_FATAL,'deprecata in favore di up_autenticazione_hash_pck.aggiorna_password');
	END IF;

	IF is_utente_dominio(pc_utente) THEN
		ut_pck.raise_log('UTENTE_DOMINIO', ut_pck.UT_FATAL,'Impossibile cambiare la password di un utente di dominio');
	END IF;

	-- Estrae dati dell'utente
	BEGIN

		log_notes := 'SELECT *' || ' FROM up_utenti WHERE utente = ' || pc_utente ;
		SELECT password
		INTO lc_pwd_db
		FROM up_utenti
		WHERE utente = pc_utente ;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			Ut_Pck.raise_log('UTENTE_INESISTENTE', Ut_Pck.UT_INFO,
			                 'Utente %1 non presente in anagrafica', pc_utente);
	END ;

	log_notes := 'Verifica le password inserite';
	-- Verifica che la password attuale sia corretta
	IF (pc_password_attuale <> lc_pwd_db ) THEN
		Ut_Pck.raise_log('PWD_UTENTE_ERRATA', Ut_Pck.UT_INFO,
		                 'Password errata per l''utente %1', pc_utente);
	END IF ;

	-- Verifica che la password nuova sia diversa dalla attuale
	IF (pc_nuova_password = pc_password_attuale ) THEN
		Ut_Pck.raise_log('PWD_UTENTE_IN_USO', Ut_Pck.UT_INFO,
		                 'La nuova password per l''utente %1 coincide con quella attuale', pc_utente);
	END IF ;

	-- Verifica che nuova password e sua conferma coincidano
	IF (pc_nuova_password <> pc_conferma_password ) THEN
		Ut_Pck.raise_log('PWD_UTENTE_NON_CONFERMATA', Ut_Pck.UT_INFO,
		                 'La nuova password per l''utente %1 non coincide con la sua conferma', pc_utente);
	END IF ;

	log_notes := '	UPDATE up_utenti SET password=' || pc_nuova_password || ' WHERE utente=' || pc_utente;
	UPDATE up_utenti
	SET password            = pc_nuova_password,
	    data_ultima_mod_pwd = SYSDATE
	WHERE utente = pc_utente;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END cambio_password;

--------------------------------------------------------------------
--
-- Nome : Up_cripta_stringa
--
-- Descrizione : Cripta stringa mediante chiave
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        17/07/2004  UM       Prima versione
--
--------------------------------------------------------------------

FUNCTION Up_cripta_stringa (
	pc_stringa  IN  VARCHAR2,
	pc_chiave   IN  VARCHAR2
) RETURN VARCHAR2 IS

	-- Variabili locali
	lc_stringa              VARCHAR2(40);
	lc_chiave               VARCHAR2(40);
	lc_stringa_cript        VARCHAR2(40);

	-- Variabili locali utilizzate per gestire i log
	lc_msg         		VARCHAR2(200);

BEGIN

	-- Riempimento stringa e chiave
	lc_msg := 'Riempimento stringa e chiave ' ;
	lc_stringa := RPAD( pc_stringa, 40, ' ' ) ;
	lc_chiave  := RPAD( pc_chiave, 40, ' ' ) ;

	-- Criptazione stringa
	lc_msg := 'Call DBMS_OBFUSCATION_TOOLKIT.DESEncrypt : ' ||
	          ' stringa = ' || lc_stringa || ', ' ||
	          ' chiave = ' || lc_chiave ;
	lc_stringa_cript := DBMS_OBFUSCATION_TOOLKIT.DESEncrypt( lc_stringa, key_string => lc_chiave ) ;

	RETURN ( lc_stringa_cript ) ;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END;

--------------------------------------------------------------------
--
-- Nome : Up_decripta_stringa
--
-- Descrizione : Decripta stringa mediante chiave
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        17/07/2004  UM       Prima versione
--
--------------------------------------------------------------------
FUNCTION Up_decripta_stringa (
	pc_stringa_cript     IN  VARCHAR2,
	pc_chiave            IN  VARCHAR2
) RETURN VARCHAR2 IS

	lc_stringa         VARCHAR2(40);
	lc_chiave          VARCHAR2(40);
	lc_stringa_cript   VARCHAR2(40);
	lc_msg             VARCHAR2(200);

BEGIN

	-- Inizializzazione parametri di uscita
	lc_msg := 'Inizializzazione parametri di uscita' ;

	-- Riempimento stringa e chiave
	lc_msg := 'Riempimento stringa criptata e chiave ' ;

	lc_stringa_cript := RPAD( pc_stringa_cript, 40, ' ' ) ;
	lc_chiave        := RPAD( pc_chiave, 40, ' ' ) ;

	-- Criptazione stringa
	lc_msg := 'Call DBMS_OBFUSCATION_TOOLKIT.DESDecrypt : ' ||
	          ' stringa_cript = ' || lc_stringa_cript || ', ' ||
	          ' chiave = ' || lc_chiave ;

	lc_stringa := DBMS_OBFUSCATION_TOOLKIT.DESDecrypt( lc_stringa_cript, key_string => lc_chiave ) ;

	RETURN (lc_stringa);

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END;

--------------------------------------------------------------------
--
-- Nome : inserimento_utente
--
-- Descrizione : Inserimento Utente con controllo password
--               con in input sito e profilo
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        20/02/2008  RGI       Prima versione
-- 2.0        26/01/2024  RBE       password con hash
-- 2.1        19/06/2024  RBE       adattamenti in base alla nuova Wlib v9
----------------------------------------------------------------------
PROCEDURE inserimento_utente (
	in_utente              IN up_utenti.utente%TYPE,
	in_descrizione         IN up_utenti.descrizione%TYPE,
	in_is_pwd_hash         IN VARCHAR2,
	in_password            IN up_utenti.password%TYPE,
	in_password_conferma   IN up_utenti.password%TYPE,
	in_sito_default        IN up_utenti.sito_default%TYPE,
	in_email               IN up_utenti.email%TYPE,
	in_serial_id           IN up_utenti.serial_id%TYPE,
	in_profilo             IN up_profili_t.profilo%TYPE,
	in_lingua_def          IN up_utenti.lingua_def%TYPE
) IS

	lc_up_utenti                up_utenti%ROWTYPE;
	lc_ut_siti                  ut_siti%ROWTYPE;
	lc_up_profili               up_profili_t%ROWTYPE;
	lc_profilo                  up_profili_t.profilo%TYPE;
	ln_conto INTEGER;

	-- Variabili locali utilizzate per gestire i log
	lc_msg  ut_allarmi.msg_allarme%TYPE;
	lr_token up_token_utente.token%TYPE;
	lr_utenti_app up_utenti_applicazioni%ROWTYPE;
	lb_gestione_hash BOOLEAN;
	lc_f_question VARCHAR2(1 BYTE);

BEGIN

	lc_msg := 'Valori in input - '||
	          'utente='||in_utente||', '||
	          'descrizione='||in_descrizione||', '||
	          'sito_default='||in_sito_default||', '||
	          'email='||in_email||', '||
	          'serial_id='||in_serial_id;

	lc_up_utenti.utente              := in_utente;
	lc_up_utenti.descrizione         := in_descrizione;
	lc_up_utenti.sito_default        := in_sito_default;
	lc_up_utenti.email               := in_email;
	lc_up_utenti.serial_id           := in_serial_id;
	lc_up_utenti.data_connessione    := SYSDATE;
	lc_up_utenti.data_ultima_mod_pwd := SYSDATE;
	lc_up_utenti.lingua_def          := in_lingua_def;

	lc_msg := 'Controllo password' ;

	lc_msg := 'Controllo Esistenza Sito ';
	BEGIN
		SELECT * INTO lc_ut_siti
		FROM ut_siti
		WHERE sito = in_sito_default
		FOR UPDATE;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			Ut_Pck.raise_log('SITO_INESISTENTE', Ut_Pck.UT_INFO,
			                 'Il Sito %1 non esiste', in_sito_default);
	END;

	lb_gestione_hash := in_is_pwd_hash = FLAG_S;

	IF is_utente_dominio(lc_up_utenti.utente) THEN
		lc_up_utenti.password := NULL;
		lb_gestione_hash := FALSE;

		IF lc_up_utenti.password IS NOT NULL THEN
			Ut_Pck.raise_log('PASSWORD_VUOTA', Ut_Pck.UT_INFO, 'Utente di dominio, non popolare la password');
		END IF;
	ELSE

		lc_up_utenti.password := in_password;
		IF lc_up_utenti.password IS NULL THEN
			Ut_Pck.raise_log('PASSWORD_OBBLIGATORIO', Ut_Pck.UT_INFO, 'Password obbligatoria');
		END IF;

		lc_msg := 'Controllo password' ;
		IF in_password != in_password_conferma THEN
			Ut_Pck.raise_log('CONFERMA_PWD_UTENTE_ERRATA', Ut_Pck.UT_INFO, 'Password di conferma errata');
		END IF;
	END IF;

	-- INSERIMENTO UTENTE IN WISE01.UP_UTENTI
	lc_msg := 'INSERT INTO UP_UTENTI - '||
	          'utente='||in_utente||', '||
	          'descrizione='||in_descrizione||', '||
	          'sito_default='||in_sito_default||', '||
	          'email='||in_email||', '||
	          'serial_id='||in_serial_id;

	INSERT INTO up_utenti(
		utente,
		descrizione,
		password,
		sito_default,
		email,
		serial_id,
		data_connessione,
		data_ultima_mod_pwd,
		lingua_def,
		cr
	) VALUES (
		lc_up_utenti.utente,
		lc_up_utenti.descrizione,
		lc_up_utenti.password,
		lc_up_utenti.sito_default,
		lc_up_utenti.email,
		lc_up_utenti.serial_id,
		lc_up_utenti.data_connessione,
		lc_up_utenti.data_ultima_mod_pwd,
		lc_up_utenti.lingua_def,
		cr_pck.crea
	);

	IF lb_gestione_hash THEN
		lc_msg := 'up_autenticazione_hash_pck.trasforma_in_utente_hash('||lc_up_utenti.utente;
		up_autenticazione_hash_pck.trasforma_in_utente_hash(lc_up_utenti.utente);
	END IF;

	-- ASSEGNAZIONE PROFILO A UTENTE NEL SISTEMA PRESCELTO
	lc_msg := 'assegna_profilo( '||in_utente||' , '||in_profilo;
	assegna_profilo(in_utente, in_profilo);

	lc_msg := 'INSERT INTO UP_UTENTI_SITI - '||
	          'utente='||in_utente||', '||
	          'sito='||in_sito_default;

	INSERT INTO up_utenti_siti(
		utente,
		sito,
		cr
	) VALUES (
		lc_up_utenti.utente,
		lc_ut_siti.sito,
		Cr_Pck.crea
	);

	-- FRA 11/08/2023 Inserimento ei dati nelle tabelle WI
	BEGIN
		FOR c IN (
			SELECT *
			FROM wise40.wi_config_t
			WHERE config = 'DEFAULT'
		) LOOP

			lc_msg := 'wise40.wi_configurazione_pck.associa_utente';
			wise40.wi_configurazione_pck.associa_utente(c.applicazione, c.config, lc_up_utenti.utente, FLAG_S);

		END LOOP;

	EXCEPTION
		WHEN OTHERS THEN
			NULL;
	END;

	IF lb_gestione_hash THEN
		lc_msg := 'up_autenticazione_hash_pck.genera_token_cambio_pwd( '||in_utente;
		lr_token := up_autenticazione_hash_pck.genera_token_cambio_pwd(in_utente);
		ut_pck.show_message('Cambia Password', 'CAMBIA_PWD', ut_pck.UT_OK,
			'Utente creato con successo, usare il token creato per effettuare in cambio della password',
			lc_f_question, lc_msg);
	END IF;

	-- RBE 19/02/2024
	-- inserimeti per applicazione web
	FOR app_web IN (
		SELECT applicazione FROM up_applicazioni_t
		 WHERE UPPER(applicazione) LIKE '%WEB%'
	) LOOP

		lr_utenti_app.applicazione := app_web.applicazione;
		lr_utenti_app.cr := cr_pck.crea;
		lr_utenti_app.utente := in_utente;

		lc_msg := 'INSERT INTO wise01.up_utenti_applicazioni '||lr_utenti_app.utente;
		INSERT INTO wise01.up_utenti_applicazioni VALUES lr_utenti_app;

	END LOOP;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,  SQLERRM, lc_msg);
		RAISE;
END inserimento_utente;

--------------------------------------------------------------------------------
-- modifica_utente
--------------------------------------------------------------------------------
PROCEDURE modifica_utente (
	in_utente              IN up_utenti.utente%TYPE,
	in_descrizione         IN up_utenti.descrizione%TYPE,
	in_sito_default        IN up_utenti.sito_default%TYPE,
	in_email               IN up_utenti.email%TYPE,
	in_serial_id           IN up_utenti.serial_id%TYPE,
	in_data_connessione    IN up_utenti.data_connessione%TYPE,
	in_data_ultima_mod_pwd IN up_utenti.data_ultima_mod_pwd%TYPE,
	in_lingua_def          IN up_utenti.lingua_def%TYPE,
	in_prog_reg            IN NUMBER
)  IS

	lc_up_utenti  up_utenti%ROWTYPE;
	log_notes     VARCHAR2(1000);
	lc_cr         up_utenti.cr%TYPE;

BEGIN

	log_notes := 'Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg)';
	SELECT cr
	INTO lc_cr
	FROM up_utenti
	WHERE utente = in_utente;

	Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg);

	log_notes := 'UPDATE UP_UTENTI - '||
	          'descrizione='||in_descrizione||', '||
	          'sito_default='||in_sito_default||', '||
	          'email='||in_email||', '||
	          'serial_id='||in_serial_id||', '||
	          'data_connessione='||in_data_connessione||', '||
	          'data_ultima_mod_pwd='||in_data_ultima_mod_pwd;

	UPDATE up_utenti
	SET descrizione         = in_descrizione,
	    sito_default        = in_sito_default,
	    email               = in_email,
	    serial_id           = in_serial_id,
	    data_connessione    = in_data_connessione,
	    data_ultima_mod_pwd = in_data_ultima_mod_pwd,
	    lingua_def          = in_lingua_def,
	    cr                  = Cr_Pck.modifica(cr, in_prog_reg)
	WHERE utente = in_utente;

EXCEPTION
	WHEN NO_DATA_FOUND THEN RAISE;
	WHEN OTHERS THEN
		ut_pck.oracle_log(SQLCODE, SQLERRM, log_notes);
		RAISE;
END modifica_utente;
--------------------------------------------------------------------------------
-- disabilita l'intero menu2
--------------------------------------------------------------------------------
PROCEDURE disabilita_menu2 (
	in_profilo        IN up_profili_t.profilo%TYPE,
	in_applicazione   IN up_applicazioni_t.applicazione%TYPE
) IS

	lc_msg     ut_allarmi.msg_allarme%TYPE;

BEGIN
	FOR c_menu IN (
		SELECT *
		FROM wise40.wi_menu2
		WHERE tipo_menu NOT IN( 'WApp', 'JPopupMenu')
		AND applicazione = NVL(in_applicazione, applicazione)
	) LOOP

		BEGIN

			lc_msg := 'INSERT INTO wise40.wi_menu2_disabilitati - profilo = ' || in_profilo ||
						 ', applicazione = ' || c_menu.applicazione || ', nome = ' || c_menu.nome || ', nome_padre = ' || c_menu.nome_padre;

			INSERT INTO wise40.wi_menu2_disabilitati ( nome, nome_padre, applicazione, profilo, tipo_abilitazione )
			VALUES ( c_menu.nome, c_menu.nome_padre, c_menu.applicazione, in_profilo, wise40.wi_menu2_abilitazioni_pck.WI_MENU2_DISAB_N );

		EXCEPTION
			WHEN dup_val_on_index THEN
				NULL;
		END;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		ut_pck.raise_log(SQLCODE, SQLERRM, lc_msg);
		RAISE;
END disabilita_menu2;
--------------------------------------------------------------------
--
-- Nome : inserimento_profilo
--
-- Descrizione : Inserimento Profilo a partire da uno già esistente
--               con caricamento dettagli profilo
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        21/02/2008  RGI       Prima versione
--
--------------------------------------------------------------------
PROCEDURE inserimento_profilo (
	in_profilo              IN up_profili_t.profilo%TYPE,
	in_descrizione          IN up_utenti.descrizione%TYPE,
	in_profilo_base         IN up_profili_t.profilo%TYPE,
	in_applicazione         IN up_applicazioni_t.applicazione%TYPE,
	in_f_disabilita_tutto   IN VARCHAR2 DEFAULT FLAG_N
)  IS

	lc_msg  VARCHAR2(200);

BEGIN

	BEGIN

		lc_msg := 'INSERT INTO up_profili_t - '||
					 'profilo = '||in_profilo||', '||
					 'descrizione = '||in_descrizione;
		INSERT INTO up_profili_t (profilo, descrizione, cr)
		VALUES (in_profilo, in_descrizione, cr_pck.crea());

	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			NULL;
	END;


	IF in_f_disabilita_tutto = FLAG_S THEN

		disabilita_menu2(in_profilo,in_applicazione);

	ELSE


		FOR c_prof IN (
			SELECT *
			FROM wise40.wi_menu2_disabilitati d
			WHERE d.applicazione = NVL ( in_applicazione, d.applicazione)
			AND d.profilo = in_profilo_base
		) LOOP

			BEGIN

				lc_msg := 'INSERT INTO wise40.wi_menu2_disabilitati - profilo = ' || in_profilo ||
							 ', applicazione = ' || c_prof.applicazione || ', nome = ' || c_prof.nome || ', nome_padre = ' || c_prof.nome_padre;

				INSERT INTO wise40.wi_menu2_disabilitati ( nome, nome_padre, applicazione, profilo, tipo_abilitazione )
				VALUES ( c_prof.nome, c_prof.nome_padre, c_prof.applicazione, in_profilo, c_prof.tipo_abilitazione );

				COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
					Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
					ROLLBACK;
			END;

		END LOOP;

	END IF;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END inserimento_profilo;

--------------------------------------------------------------------
--
-- Nome : abilita
--
-- Descrizione : Abilitazione  Funzioni collegate a profili
--
-- Versione   Data        Autore   Descrizione
--
-- 1.0        21/02/2008  RGI       Prima versione
--
--------------------------------------------------------------------

PROCEDURE abil_disabil_funzione (
	in_profilo      IN up_profili_d.profilo%TYPE,
	in_applicazione IN up_profili_d.applicazione%TYPE,
	in_funzione     IN up_profili_d.funzione%TYPE,
	in_f_att        IN VARCHAR2,
	in_prog_reg     IN NUMBER
)  IS

	lc_up_profili_d  up_profili_d%ROWTYPE;
	log_notes        VARCHAR2(1000);
	lc_cr            up_profili_d.cr%TYPE;

BEGIN

	log_notes := 'Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg)';
	SELECT cr
	INTO lc_cr
	FROM up_profili_d
	WHERE profilo = in_profilo
	AND applicazione = in_applicazione
	AND funzione = in_funzione;

	Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg);

	log_notes := 'UPDATE UP_Profili';
	IF (in_f_att = 'S') THEN
		lc_cr := Cr_Pck.attiva(lc_cr,in_prog_reg);
	ELSE
		lc_cr := Cr_Pck.disattiva(lc_cr,in_prog_reg);
	END IF;

	log_notes := lc_cr;

	UPDATE up_profili_d
	SET cr = lc_cr
	WHERE profilo = in_profilo
	AND applicazione = in_applicazione
	AND funzione = in_funzione;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END abil_disabil_funzione;

--------------------------------------------------------------------------------
--Inserisce una nuova funzione e la abilita al profilo inserito in input
--oppure a tutti i profili se in_profilo è null
PROCEDURE aggiunta_funzione(
	in_funzione    IN up_applicazioni_d.funzione%TYPE,
	in_descrizione IN up_applicazioni_d.descrizione%TYPE,
	in_profilo     IN up_profili_t.profilo%TYPE DEFAULT NULL
) IS

	lc_msg 				VARCHAR2(100);
	lc_applicazioni_d up_applicazioni_d%ROWTYPE;
	lc_profili_d      up_profili_d%ROWTYPE;

BEGIN

	lc_msg := 'Caricamento Dati Dettaglio Applicazione';
	lc_applicazioni_d.applicazione := 'W-Log';
	lc_applicazioni_d.funzione     := in_funzione;
	lc_applicazioni_d.descrizione  := in_descrizione;
	lc_applicazioni_d.cr           := Cr_pck.crea;

	lc_msg := 'Inserimento Dati Dettaglio Applicazione';
	INSERT INTO up_applicazioni_d VALUES lc_applicazioni_d;

	IF (in_profilo IS NULL ) THEN
		lc_msg := 'Ciclo tutti i profili';
		FOR c IN(
			SELECT profilo
			FROM up_profili_t
		)LOOP
			BEGIN
				SELECT *
				INTO lc_profili_d
				FROM up_profili_d
				WHERE profilo = c.profilo
				AND applicazione = 'W-Log'
				AND funzione = in_funzione;
			EXCEPTION
            WHEN NO_DATA_FOUND THEN
					lc_msg := 'Caricamento Dati Dettaglio Profilo ' || c.profilo;
					lc_profili_d.profilo      := c.profilo;
					lc_profili_d.applicazione := 'W-Log';
					lc_profili_d.funzione     := in_funzione;
					lc_profili_d.cr           := Cr_pck.crea;
					lc_msg := 'Inserimento Dati Dettaglio Profilo ' || c.profilo;
					INSERT INTO up_profili_d VALUES lc_profili_d;
			END;
		END LOOP;
	ELSE
		lc_msg := 'Caricamento Dati Dettaglio Profilo ' || in_profilo;
		lc_profili_d.profilo      := in_profilo;
		lc_profili_d.applicazione := 'W-Log';
		lc_profili_d.funzione     := in_funzione;
		lc_profili_d.cr           := cr_pck.crea;
		lc_msg := 'Inserimento Dati Dettaglio Profilo ' || in_profilo;
		INSERT INTO up_profili_d VALUES lc_profili_d;
	END IF;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END aggiunta_funzione;

--------------------------------------------------------------------------------
PROCEDURE set_variabili_contesto (
	pc_utente       IN  up_utenti.utente%TYPE,
	pc_sito         IN  ut_siti.sito%TYPE,
	pc_terminale    IN  VARCHAR2,
	pc_applicazione IN  up_applicazioni_t.applicazione%TYPE,
	pc_lingua       IN  wise40.wi_lingue.lingua%TYPE DEFAULT 'IT'
) IS

	lc_nls_language  wise40.wi_lingue.nls_language%TYPE;

BEGIN

	Am_pck.set_utente(pc_utente);
	Am_pck.set_sito(pc_sito);
	Am_pck.set_terminale(NVL(pc_terminale, USERENV('TERMINAL')));
	Am_pck.set_applicazione(pc_applicazione);
	SYS.dbms_application_info.set_client_info(pc_applicazione||'.'||pc_utente||' - '||substr(pc_terminale, INSTR(pc_terminale, ' [')+1, LENGTH(pc_terminale)));

	-- MOG 26/09/2017 aggiunto per il set della postazioni di lavoro
	FOR c IN (
		SELECT *
		FROM up_terminali_attributi
		WHERE terminale = NVL(pc_terminale, USERENV('TERMINAL'))
	) LOOP
		Am_pck.Set_Attributo(in_attributo=> c.attributo, in_valore=> c.valore);
	END LOOP;

	-- Settaggio lingua
	-- Estrae dati dell'utente
	BEGIN

		SELECT nls_language
		INTO lc_nls_language
		FROM wise40.wi_lingue
		WHERE lingua = pc_lingua;

		-- Setto subito la lingua per eventuali messaggi di errore
		Am_pck.set_lingua(pc_lingua);
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = '||lc_nls_language;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			Am_pck.set_lingua(LINGUA_IT);
			EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = '||NLS_ITALIAN;
	END ;

EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;

--------------------------------------------------------------------------------
PROCEDURE verifica_utente_generale (
	pc_utente       IN  up_utenti.utente%TYPE,
	pc_password     IN  up_utenti.password%TYPE,
	pc_terminale    IN  VARCHAR2,  --- Se chiamata da Java Userenv('TERMINAL') restituisce unknown
	pc_applicazione IN up_applicazioni_t.applicazione%TYPE,
	pc_msg          OUT VARCHAR2
) IS

	-- Variabili locali
	ld_sysdate              DATE;
	lc_utente               up_utenti.utente%TYPE;
	lc_password             up_utenti.password%TYPE;
	lc_password_attuale     up_utenti.password%TYPE;
	ld_data_ultima_mod_pwd  up_utenti.data_ultima_mod_pwd%TYPE;
	lc_f_inattivo           VARCHAR2(1);
	ld_data_inattivo        DATE;

	-- Variabili locali utilizzate per gestire i log
	lc_msg                 VARCHAR2(1000);
	ln_esito               INTEGER;
	lc_conto               NUMBER;

	PAR_GG_DURATA_PWD  ut_parametri_siti.valore%TYPE;

BEGIN

	-- Inizializzazione parametri di uscita
	lc_msg := 'Inizializzazione parametri di uscita' ;
	pc_msg        := '' ;

	-- Inizializzazione costanti
	lc_msg := 'Inizializzazione costanti';
	ld_sysdate     := SYSDATE;

	-- Estrae dati dell'utente
	BEGIN

		lc_msg := 'SELECT data_ultima_mod_pwd, profilo' ||
		          ' FROM up_utenti' ||
		          ' WHERE utente = ' || pc_utente ;

		SELECT DISTINCT password, f_inattivo
		INTO lc_password_attuale, lc_f_inattivo
		FROM up_utenti_profili_v01
		WHERE utente = pc_utente ;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			Ut_Pck.raise_log('UTENTE_INESISTENTE', Ut_Pck.UT_INFO,
			                 'Utente %1 non presente in anagrafica', pc_utente);
	END ;

	lc_password := pc_password;
	lc_msg := 'Controllo la password' ;

	IF ( lc_password != lc_password_attuale ) THEN
		Ut_Pck.raise_log('PWD_UTENTE_ERRATA', Ut_Pck.UT_INFO,
		                 'Password errata per l''utente %1', pc_utente);
	END IF ;

	-- Controllo abilitazione
	lc_msg := 'Controllo abilitazione' ;
	IF ( lc_f_inattivo = 'S' ) THEN
		Ut_Pck.raise_log('UTENTE_NON_ABILITATO', Ut_Pck.UT_INFO,
		                 'Utente %1 non abilitato.', pc_utente);
	END IF ;

	Am_pck.set_utente(pc_utente);
	Am_pck.set_terminale(NVL(pc_terminale, USERENV('TERMINAL')));
	Am_pck.set_applicazione(pc_applicazione);
	SYS.dbms_application_info.set_client_info(pc_applicazione||'.'||pc_utente);

 /*    -- Verifica scadenza password
    -- Estrae parametro utente di durata dei dati ut
    lc_msg := 'Call ut_pck.ut_leggi_parametro_utente : parametro = ' || NOME_PAR_GG_DURATA_PWD ;
    PAR_GG_DURATA_PWD := ut_pck.leggi_parametro_utente ( lc_sito, NOME_PAR_GG_DURATA_PWD) ;


    -- Avverto se mancano meno di 10 gg alla scadenza o se la pwd e scaduta
    -- Controllo Password
    lc_msg := 'Controllo Password' ;
    IF ( ( ld_data_ultima_mod_pwd + PAR_GG_DURATA_PWD ) < ld_sysdate ) THEN

        Ut_Pck.raise_log('PWD_SCADUTA', Ut_Pck.UT_INFO, 'up_pck', 'verifica_utente',
                              'Password scaduta');

  ELSIF ( ( ld_data_ultima_mod_pwd + PAR_GG_DURATA_PWD ) < ( ld_sysdate + 10 ) ) THEN

    -- Password in scadenza
    pc_msg   := 'La password corrente scade tra ' || ( ld_sysdate + 10 ) -
                ( ld_data_ultima_mod_pwd + PAR_GG_DURATA_PWD ) || ' giorni.' ;

  END IF ;
*/

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
		RAISE;
END verifica_utente_generale;

--------------------------------------------------------------------------------
PROCEDURE abil_disabil_applicazione (
	in_utente       IN up_utenti_applicazioni.utente%TYPE,
	in_applicazione IN up_utenti_applicazioni.applicazione%TYPE,
	in_f_att        IN VARCHAR2,
	in_prog_reg     IN NUMBER
)  IS

	lc_up_profili_d  up_profili_d%ROWTYPE;
	log_notes        VARCHAR2(1000);
	lc_cr            up_profili_d.cr%TYPE;

BEGIN

	log_notes := 'Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg)';
	SELECT cr
	INTO lc_cr
	FROM up_utenti_applicazioni
	WHERE utente = in_utente
	AND applicazione = in_applicazione;

	Cr_Pck.verifica_se_modificato(lc_cr,in_prog_reg);

	log_notes := 'UPDATE up_utenti_applicazioni';
	IF (in_f_att = 'S') THEN
		lc_cr := Cr_Pck.attiva(lc_cr,in_prog_reg);
	ELSE
		lc_cr := Cr_Pck.disattiva(lc_cr,in_prog_reg);
	END IF;

	log_notes:=lc_cr;

	UPDATE up_utenti_applicazioni
	SET cr = lc_cr
	WHERE utente = in_utente
	AND applicazione = in_applicazione;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END abil_disabil_applicazione;

--------------------------------------------------------------------------------

PROCEDURE Invia_Notifiche(
	in_id_allarme   IN   ut_allarmi.id_allarme%TYPE,
	in_cod_allarme  IN   ut_allarmi.cod_allarme%TYPE
)IS
	lc_msg             ut_allarmi.msg_allarme%TYPE;
	lc_conto           INTEGER;
BEGIN

	FOR c IN (
		SELECT g.id_gruppo, g.cod_allarme, g.utente, g.profilo, g.sito, g.f_invio_mail, g.severita,
		       DECODE( g.utente, NULL, DECODE( g.profilo, NULL, DECODE( g.sito, NULL, NULL, UP_TIPO_DEST_SITO ), UP_TIPO_DEST_PROFILO ), UP_TIPO_DEST_UTENTE) tipo_dest
		FROM up_gruppi_ricezione g
		WHERE cod_allarme = in_cod_allarme
	)LOOP

		invia_messaggio( am_pck.GET_APPLICAZIONE, c.tipo_dest, NVL( c.sito, NVL( c.profilo, c.utente ) ) , '#LOG#' || in_id_allarme, NULL, c.severita );

		IF (c.f_invio_mail = FLAG_S) THEN
			invia_mail_allarme(c.tipo_dest, NVL( c.sito, NVL( c.profilo, c.utente ) ), in_id_allarme);
		END IF;

	END LOOP;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END;

--------------------------------------------------------------------------------

PROCEDURE Invia_Notifiche(
	in_id_allarme     IN ut_allarmi.id_allarme%TYPE,
	in_cod_allarme    IN ut_allarmi.cod_allarme%TYPE,
	in_data_creazione IN ut_allarmi.data_creazione%TYPE,
	in_utente         IN ut_allarmi.utente%TYPE,
	in_msg_allarme    IN ut_allarmi.msg_allarme%TYPE
)IS
	lc_msg             ut_allarmi.msg_allarme%TYPE;
	lc_conto           INTEGER;
BEGIN

	FOR c IN (
		SELECT g.id_gruppo, g.cod_allarme, g.utente, g.profilo, g.sito, g.f_invio_mail, g.severita,
		       DECODE( g.utente, NULL, DECODE( g.profilo, NULL, DECODE( g.sito, NULL, NULL, UP_TIPO_DEST_SITO ), UP_TIPO_DEST_PROFILO ), UP_TIPO_DEST_UTENTE) tipo_dest
		FROM up_gruppi_ricezione g
		WHERE cod_allarme = in_cod_allarme
	)LOOP

		invia_messaggio( am_pck.GET_APPLICAZIONE, c.tipo_dest, NVL( c.sito, NVL( c.profilo, c.utente ) ) , '#LOG#' || in_id_allarme, NULL, c.severita );

		IF (c.f_invio_mail = FLAG_S) THEN
			invia_mail_allarme(c.tipo_dest, NVL( c.sito, NVL( c.profilo, c.utente ) ), in_id_allarme, in_data_creazione, in_utente, in_cod_allarme, in_msg_allarme);
		END IF;

	END LOOP;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END;

--------------------------------------------------------------------------------
PROCEDURE invia_messaggio(
	in_mittente       IN up_messaggi.mittente%TYPE,
	in_tipo_dest      IN VARCHAR2,
	in_dest           IN VARCHAR2,
	in_oggetto        IN up_messaggi.oggetto%TYPE,
	in_testo          IN up_messaggi.testo%TYPE,
	in_severita       IN up_messaggi.severita%TYPE DEFAULT UP_SEVERITA_MESSAGGIO_NOTIFICA
) IS

	lc_msg                  ut_allarmi.msg_allarme%TYPE;
	lc_parametro            ut_parametri%ROWTYPE;
	lc_destinatario         VARCHAR2(20);
	lc_tipo_destinatario    VARCHAR2(10);
	lc_progr_utente         up_gruppi_ricezione.id_gruppo%TYPE;
	lc_severita             up_messaggi.severita%TYPE;

BEGIN

	IF in_severita IS NULL THEN
		lc_severita := UP_SEVERITA_MESSAGGIO_NOTIFICA;
	ELSE
		lc_severita := in_severita;
	END IF;

   IF (in_tipo_dest = UP_TIPO_DEST_UTENTE) THEN

      SELECT NVL(MAX(prog_utente)+1,1)
        INTO lc_progr_utente
        FROM up_messaggi
       WHERE destinatario = in_dest;

      lc_msg := 'INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, prog_utente) ' ||
                'VALUES (up_messaggi_progr.NEXTVAL,'|| SYSDATE||','|| in_oggetto||','|| am_pck.get_utente||','|| in_dest||','|| in_testo||','|| FLAG_N||','|| lc_progr_utente;
      INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, severita, prog_utente)
      VALUES (up_messaggi_progr.NEXTVAL, SYSDATE, in_oggetto, in_mittente, in_dest, in_testo, FLAG_N, lc_severita, lc_progr_utente);

   ELSIF (in_tipo_dest = UP_TIPO_DEST_PROFILO) THEN

      FOR c IN (
			SELECT p.utente, u.email
			FROM up_profili_utenti p, up_utenti u
			WHERE profilo = in_dest
			AND p.utente = u.utente (+)
      ) LOOP

			SELECT NVL (MAX (prog_utente) + 1, 1)
			INTO lc_progr_utente
			FROM up_messaggi
			WHERE destinatario = c.utente;

         lc_msg := 'INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, prog_utente) ' ||
                  'VALUES (up_messaggi_progr.NEXTVAL,'|| SYSDATE||','|| in_oggetto||','|| am_pck.get_utente||','|| c.utente||','|| in_testo||','|| FLAG_N||','|| lc_progr_utente;
         INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, severita, prog_utente)
         VALUES (up_messaggi_progr.NEXTVAL, SYSDATE, in_oggetto, in_mittente, c.utente, in_testo, FLAG_N, lc_severita, lc_progr_utente);

      END LOOP;

	-- RBE 07/06/2021
	-- introduzione nuovo tipo destinazione
	ELSIF in_tipo_dest = UP_TIPO_DEST_TERMINALE THEN

		-- nuovo tipo introdotto.
		-- inserisce un messaggio per ogni utente presnte tra le sessioni oracle con terminale
		-- uguale a quello in input
		FOR c IN (
			SELECT SUBSTR( REGEXP_SUBSTR ( REPLACE( client_info, ' - ', '#'), '[^#]+', 1, 1), INSTR( REGEXP_SUBSTR ( REPLACE( client_info, ' - ', '#'), '[^#]+', 1, 1), '.' )+1 ) utente
			FROM v$session
			WHERE client_info IS NOT NULL
			AND REGEXP_SUBSTR (REPLACE( client_info, ' - ', '#'), '[^#]+', 1, 2) = in_dest
		) LOOP

			SELECT NVL (MAX (prog_utente) + 1, 1)
			INTO lc_progr_utente
			FROM up_messaggi
			WHERE destinatario = c.utente;

			lc_msg := 'INSERT INTO ut_messaggi VALUES (up_messaggi_progr.NEXTVAL,'|| SYSDATE||','
				|| in_oggetto||','|| am_pck.get_utente||','|| c.utente||','|| in_testo
				||','|| FLAG_N||','|| lc_progr_utente||', '||lc_severita;
			INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura,prog_utente, severita)
			VALUES (up_messaggi_progr.NEXTVAL, SYSDATE, in_oggetto, in_mittente, c.utente, in_testo, FLAG_N, lc_progr_utente, lc_severita);

		END LOOP;

   ELSE

      FOR c IN (
			SELECT s.utente, u.email
			FROM up_utenti_siti s, up_utenti u
			WHERE s.sito = in_dest
			AND s.utente = u.utente (+)
      ) LOOP

         SELECT NVL (MAX (prog_utente) + 1, 1)
           INTO lc_progr_utente
           FROM up_messaggi
          WHERE destinatario = in_dest;

         lc_msg := 'INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, prog_utente) ' ||
                  'VALUES (up_messaggi_progr.NEXTVAL,'|| SYSDATE||','|| in_oggetto||','|| am_pck.get_utente||','|| c.utente||','|| in_testo||','|| FLAG_N||','|| lc_progr_utente;
         INSERT INTO up_messaggi (progressivo, data, oggetto, mittente, destinatario, testo, f_lettura, severita, prog_utente)
         VALUES (up_messaggi_progr.NEXTVAL, SYSDATE, in_oggetto, in_mittente, c.utente, in_testo, FLAG_N, lc_severita, lc_progr_utente);

      END LOOP;

   END IF;

EXCEPTION
      WHEN OTHERS THEN
      Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END invia_messaggio;

--------------------------------------------------------------------------------
PROCEDURE invia_messaggio(
	in_tipo_dest   IN VARCHAR2,
	in_dest        IN VARCHAR2,
	in_oggetto     IN up_messaggi.oggetto%TYPE,
	in_testo       IN up_messaggi.testo%TYPE
) IS
    lc_msg  ut_allarmi.msg_allarme%TYPE;
BEGIN

    invia_messaggio(am_pck.get_utente, in_tipo_dest, in_dest, in_oggetto, in_testo, 0);

EXCEPTION
      WHEN OTHERS THEN
      Ut_Pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
END invia_messaggio;

--------------------------------------------------------------------------------
PROCEDURE segna_tutti_letti(
	in_param IN VARCHAR2
) IS
	lc_msg VARCHAR2(100);
BEGIN

	lc_msg := 'UPDATE up_messaggi SET f_lettura = S WHERE destinatario = '||am_pck.get_utente;
	UPDATE up_messaggi
	SET f_lettura = FLAG_S
	WHERE destinatario = am_pck.get_utente;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END segna_tutti_letti;

--------------------------------------------------------------------------------

PROCEDURE segna_letto(
	in_progressivo IN up_messaggi.progressivo%TYPE
) IS
	lc_msg VARCHAR2(100);
BEGIN

	lc_msg := 'UPDATE up_messaggi SET f_lettura = S WHERE progressivo = ' || in_progressivo;
	UPDATE up_messaggi
	SET f_lettura = FLAG_S
	WHERE progressivo = in_progressivo;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END segna_letto;

--------------------------------------------------------------------------------

PROCEDURE invia_mail_allarme (
	in_tipo_dest  IN VARCHAR2,
	in_dest       IN VARCHAR2,
	in_id_allarme IN ut_allarmi.id_allarme%TYPE
) IS

	lr_allarme      ut_allarmi%ROWTYPE;
	lc_messaggio    VARCHAR2(200);
	log_notes       VARCHAR2(2000);

BEGIN

	log_notes := 'SELECT * FROM ut_allarmi WHERE id_allarme = ' || in_id_allarme;
	SELECT *
	INTO lr_allarme
	FROM ut_allarmi
	WHERE id_allarme = in_id_allarme;

	lc_messaggio := 'In data ' || TO_CHAR(lr_allarme.data_creazione, 'DD/MM/YYYY') ||
	                ' alle ore ' || TO_CHAR(lr_allarme.data_creazione, 'HH24:MI:SS') ||
	                ' l''utente ' || lr_allarme.utente ||
	                ' ha sollevato un allarme del tipo ' || lr_allarme.cod_allarme || ': ' || CHR(13) || CHR(10) || lr_allarme.msg_allarme;

	log_notes := 'invia_mail(' || in_tipo_dest || ', ' || in_dest || ', ' || lr_allarme.cod_allarme || ' , ' || lc_messaggio || ' )';
	invia_mail(in_tipo_dest, in_dest, lr_allarme.cod_allarme, lc_messaggio);

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END invia_mail_allarme;

--------------------------------------------------------------------------------

PROCEDURE invia_mail_allarme (
	in_tipo_dest      IN VARCHAR2,
	in_dest           IN VARCHAR2,
	in_id_allarme     IN ut_allarmi.id_allarme%TYPE,
	in_data_creazione IN ut_allarmi.data_creazione%TYPE,
	in_utente_all     IN ut_allarmi.utente%TYPE,
	in_cod_allarme    IN ut_allarmi.cod_allarme%TYPE,
	in_msg_allarme    IN ut_allarmi.msg_allarme%TYPE
) IS

	lc_messaggio    VARCHAR2(4000);
	log_notes       VARCHAR2(2000);

BEGIN

	lc_messaggio := 'In data ' || TO_CHAR(in_data_creazione, 'DD/MM/YYYY') ||
	                ' alle ore ' || TO_CHAR(in_data_creazione, 'HH24:MI:SS') ||
	                ' l''utente ' || in_utente_all ||
	                ' ha sollevato un allarme del tipo ' || in_cod_allarme || ': ' || CHR(13) || CHR(10) || in_msg_allarme;

	log_notes := 'invia_mail(' || in_tipo_dest || ', ' || in_dest || ', ' || in_cod_allarme || ' , ' || lc_messaggio || ' )';
	invia_mail(in_tipo_dest, in_dest, in_cod_allarme, lc_messaggio);

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END invia_mail_allarme;

--------------------------------------------------------------------------------
PROCEDURE invia_mail(
	in_tipo_dest IN VARCHAR2,
	in_dest      IN VARCHAR2,
	in_oggetto   IN ut_mail_message.oggetto%TYPE,
	in_messaggio IN ut_mail_message.messaggio%TYPE,
	in_mittente  IN ut_mail_message.mittente%TYPE DEFAULT MAIL_SENDER_NOTIFICHE,
	in_priorita  IN ut_mail_message.priorita%TYPE DEFAULT MAIL_PRIO_NORMALE
) IS

	log_notes    ut_allarmi.msg_allarme%TYPE;
	lr_mail      ut_mail_message%ROWTYPE;

BEGIN

	IF (in_tipo_dest = UP_TIPO_DEST_UTENTE) THEN

		FOR c IN (
			SELECT u.utente, u.email
			FROM up_utenti u
			WHERE utente = in_dest
			AND u.email IS NOT NULL
		) LOOP
			lr_mail.destinatario := lr_mail.destinatario||'<'||c.email||'>;';
		END LOOP;

	ELSIF (in_tipo_dest = UP_TIPO_DEST_PROFILO) THEN

		FOR c IN (
			SELECT p.utente, u.email
			FROM up_profili_utenti p, up_utenti u
			WHERE profilo = in_dest
			AND p.utente = u.utente (+)
			AND u.email IS NOT NULL
		) LOOP
			lr_mail.destinatario := lr_mail.destinatario||'<'||c.email||'>;';
		END LOOP;

	ELSE

		FOR c IN (
			SELECT s.utente, u.email
			FROM up_utenti_siti s, up_utenti u
			WHERE sito = in_dest
			AND s.utente = u.utente (+)
			AND u.email IS NOT NULL
		) LOOP
			lr_mail.destinatario := lr_mail.destinatario||'<'||c.email||'>;';
		END LOOP;

	END IF;

	IF lr_mail.destinatario IS NULL THEN
		RETURN;
	END IF;

	lr_mail.mittente     := NVL(in_mittente, MAIL_SENDER_NOTIFICHE);
	lr_mail.oggetto      := in_oggetto;
	lr_mail.messaggio    := in_messaggio;
	lr_mail.lista_cc     := NULL;
	lr_mail.lista_ccn    := NULL;
	lr_mail.priorita     := NVL(in_priorita, MAIL_PRIO_NORMALE);

	BEGIN
		log_notes := 'ut_mail_pck.invia_ora('||lr_mail.mittente||','||lr_mail.destinatario||','||lr_mail.oggetto;
		lr_mail.id_mail := ut_mail_pck.invia_ora(
			in_mittente      => lr_mail.mittente,
			in_destinatario  => lr_mail.destinatario,
			in_oggetto       => lr_mail.oggetto,
			in_messaggio     => lr_mail.messaggio,
			in_lista_cc      => lr_mail.lista_cc,
			in_lista_ccn     => lr_mail.lista_ccn,
			in_allegati      => NULL,
			in_html          => 'S',
			in_priorita      => lr_mail.priorita);
	EXCEPTION
		WHEN OTHERS THEN
			ut_pck.oracle_log(SQLCODE, SQLERRM, log_notes);
	END;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, log_notes);
		RAISE;
END invia_mail;

--------------------------------------------------------------------------------
PROCEDURE Elimina_Utente(
	in_utente IN up_utenti.utente%TYPE
) IS

	lc_msg VARCHAR2(100);

BEGIN

	lc_msg := 'Elimina la connessione sito/utente';
	DELETE up_utenti_siti
	WHERE utente = in_utente;

	lc_msg := 'Elimina la connessione profilo/utente';
	DELETE up_profili_utenti
	WHERE utente = in_utente;

	lc_msg := 'Elimina la connessione applicazione/utente';
	DELETE up_utenti_applicazioni
	WHERE utente = in_utente;

	lc_msg := 'Elimina la connessione sito/utente/applicazione';
	DELETE up_utenti_siti_applicazioni
	WHERE utente = in_utente;

	lc_msg := 'Elimina la connessione parametri/utente';
	DELETE ut_parametri_utente
	WHERE utente = in_utente;

	lc_msg := 'Elimina le configurazioni utente d';
	DELETE wise40.wi_config_utenti_d
	WHERE utente = in_utente;

	lc_msg := 'Elimina le configurazioni utente';
	DELETE wise40.wi_config_utenti
	WHERE utente = in_utente;

	lc_msg := 'Elimina l''utente';
	DELETE up_utenti
	WHERE utente = in_utente;

EXCEPTION
	WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END Elimina_Utente;

--------------------------------------------------------------------------------
PROCEDURE salva_context_config(
    pc_utente       IN  up_utenti.utente%TYPE,
    pc_applicazione IN  up_applicazioni_t.applicazione%TYPE,
    pc_config       IN  wise40.wi_config_t.config%TYPE
) IS
    lc_msg             VARCHAR2(1000);
BEGIN

   FOR c IN(

      SELECT *
        FROM wise40.wi_config_d d
       WHERE config = pc_config
         AND applicazione = pc_applicazione
         AND LENGTH( attributo ) <= 30
   ) LOOP
      am_pck.Set_Attributo(c.attributo, c.valore);
   END LOOP;

EXCEPTION
    WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
         --RAISE;
END salva_context_config;
--------------------------------------------------------------------------------
PROCEDURE salva_trace_sessione(
   in_applicazione          IN wise01.ut_trace_sessioni.applicazione%TYPE,
   in_utente                IN wise01.ut_trace_sessioni.utente%TYPE,
   in_utente_sistema        IN wise01.ut_trace_sessioni.utente_sistema%TYPE,
   in_terminale             IN wise01.ut_trace_sessioni.terminale%TYPE,
   in_terminale_2           IN wise01.ut_trace_sessioni.terminale_2%TYPE,
   in_nome_file             IN wise01.ut_trace_sessioni.nome_file%TYPE,
   in_path_file             IN wise01.ut_trace_sessioni.path_file%TYPE,
   in_jvm                   IN wise01.ut_trace_sessioni.jvm%TYPE,
   in_os                    IN wise01.ut_trace_sessioni.os%TYPE
   --in_versione_app          IN wise01.ut_trace_sessioni.versione_app%TYPE DEFAULT 'N.C.',
   --in_versione_std          IN wise01.ut_trace_sessioni.versione_Std%TYPE DEFAULT 'N.C.'
) IS
   lc_msg             VARCHAR2(1000);
   in_versione_app    wise01.ut_trace_sessioni.versione_app%TYPE := 'N.C.';
   in_versione_std    wise01.ut_trace_sessioni.versione_Std%TYPE := '7.2.1.0';
BEGIN

   BEGIN

      INSERT INTO wise01.ut_trace_sessioni ( applicazione,
                                             versione_app,
                                             versione_std,
                                             utente,
                                             utente_sistema,
                                             terminale,
                                             terminale_2,
                                             nome_file,
                                             path_file,
                                             jvm,
                                             os,
                                             data_ultima_connessione
      ) VALUES ( in_applicazione,
                 UPPER(in_versione_app),
                 UPPER(in_versione_std),
                 UPPER(in_utente),
                 UPPER(in_utente_sistema),
                 REPLACE(UPPER(in_terminale),'.AVS.COM', ''),
                 REPLACE(UPPER(NVL(in_terminale_2, in_terminale)),'.AVS.COM', ''),
                 UPPER(in_nome_file),
                 REPLACE(UPPER(in_path_file),'.AVS.COM', ''),
                 UPPER(in_jvm),
                 UPPER(in_os),
                 SYSDATE
      );

   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN

         UPDATE wise01.ut_trace_sessioni
            SET data_ultima_connessione = SYSDATE
          WHERE applicazione   = in_applicazione
            AND versione_app   = UPPER(in_versione_app)
            AND versione_std   = UPPER(in_versione_std)
            AND utente         = UPPER(in_utente)
            AND utente_sistema = UPPER(in_utente_sistema)
            AND terminale      = REPLACE(UPPER(in_terminale),'.AVS.COM', '')
            AND terminale_2    = REPLACE(UPPER(NVL(in_terminale_2, in_terminale)),'.AVS.COM', '')
            AND nome_file      = UPPER(in_nome_file)
            AND path_file      = REPLACE(UPPER(in_path_file),'.AVS.COM', '')
            AND jvm            = UPPER(in_jvm)
            AND os             = UPPER(in_os);
   END;


EXCEPTION
    WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END salva_trace_sessione;
--------------------------------------------------------------------------------
PROCEDURE salva_trace_applicazione(
   in_applicazione          IN wise01.ut_trace_sessioni.applicazione%TYPE,
   in_versione_app          IN wise01.ut_trace_sessioni.versione_app%TYPE DEFAULT 'N.C.',
   in_versione_std          IN wise01.ut_trace_sessioni.versione_Std%TYPE DEFAULT 'N.C.',
   in_utente                IN wise01.ut_trace_sessioni.utente%TYPE,
   in_utente_sistema        IN wise01.ut_trace_sessioni.utente_sistema%TYPE,
   in_terminale             IN wise01.ut_trace_sessioni.terminale%TYPE,
   in_terminale_2           IN wise01.ut_trace_sessioni.terminale_2%TYPE,
   in_nome_file             IN wise01.ut_trace_sessioni.nome_file%TYPE,
   in_path_file             IN wise01.ut_trace_sessioni.path_file%TYPE,
   in_jvm                   IN wise01.ut_trace_sessioni.jvm%TYPE,
   in_os                    IN wise01.ut_trace_sessioni.os%TYPE
) IS
   lc_msg             VARCHAR2(1000);
BEGIN

   BEGIN

      INSERT INTO wise01.ut_trace_sessioni ( applicazione,
                                             versione_app,
                                             versione_std,
                                             utente,
                                             utente_sistema,
                                             terminale,
                                             terminale_2,
                                             nome_file,
                                             path_file,
                                             jvm,
                                             os,
                                             data_ultima_connessione
      ) VALUES ( in_applicazione,
                 UPPER(in_versione_app),
                 UPPER(in_versione_std),
                 UPPER(in_utente),
                 UPPER(in_utente_sistema),
                 REPLACE(UPPER(in_terminale),'.AVS.COM', ''),
                 REPLACE(UPPER(NVL(in_terminale_2, in_terminale)),'.AVS.COM', ''),
                 UPPER(in_nome_file),
                 REPLACE(UPPER(in_path_file),'.AVS.COM', ''),
                 UPPER(in_jvm),
                 UPPER(in_os),
                 SYSDATE
      );

   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN

         UPDATE wise01.ut_trace_sessioni
            SET data_ultima_connessione = SYSDATE
          WHERE applicazione   = in_applicazione
            AND versione_app   = UPPER(in_versione_app)
            AND versione_std   = UPPER(in_versione_std)
            AND utente         = UPPER(in_utente)
            AND utente_sistema = UPPER(in_utente_sistema)
            AND terminale      = REPLACE(UPPER(in_terminale),'.AVS.COM', '')
            AND terminale_2    = REPLACE(UPPER(NVL(in_terminale_2, in_terminale)),'.AVS.COM', '')
            AND nome_file      = UPPER(in_nome_file)
            AND path_file      = REPLACE(UPPER(in_path_file),'.AVS.COM', '')
            AND jvm            = UPPER(in_jvm)
            AND os             = UPPER(in_os);
   END;


EXCEPTION
    WHEN OTHERS THEN
		Ut_Pck.oracle_log(SQLCODE,   SQLERRM, lc_msg);
END salva_trace_applicazione;


PROCEDURE insert_ut_note_promemoria (
    in_utente           IN  WISE01.ut_note_promemoria.utente%TYPE,
    in_progressivo      IN  WISE01.ut_note_promemoria.progressivo%TYPE,
    in_titolo           IN  WISE01.ut_note_promemoria.titolo%TYPE,
    in_testo            IN  WISE01.ut_note_promemoria.testo%TYPE,
    in_tipologia        IN  WISE01.ut_note_promemoria.tipologia%TYPE,
    in_colore           IN  WISE01.ut_note_promemoria.colore%TYPE,
    in_data_promemoria  IN  WISE01.ut_note_promemoria.data_promemoria%TYPE,
    in_applicazione     IN  WISE01.ut_note_promemoria.applicazione%TYPE
  )  IS

  lr_ut_note_promemoria  WISE01.ut_note_promemoria%ROWTYPE;
  lc_msg  VARCHAR2(1000);

BEGIN

  lc_msg := 'Valori in input';

  lr_ut_note_promemoria.utente           := in_utente;
  lr_ut_note_promemoria.progressivo      := in_progressivo;
  lr_ut_note_promemoria.titolo           := in_titolo;
  lr_ut_note_promemoria.testo            := in_testo;
  lr_ut_note_promemoria.tipologia        := in_tipologia;
  lr_ut_note_promemoria.colore           := in_colore;
  lr_ut_note_promemoria.data_promemoria  := in_data_promemoria;
  lr_ut_note_promemoria.applicazione     := in_applicazione;
  lr_ut_note_promemoria.cr               := wise01.cr_pck.crea;

  lc_msg := 'INSERT INTO WISE01.ut_note_promemoria';

  INSERT INTO WISE01.ut_note_promemoria VALUES lr_ut_note_promemoria;

EXCEPTION
  WHEN OTHERS THEN
    WISE01.ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
    RAISE;

END insert_ut_note_promemoria;
------------------------------------------------------------------------------------------
FUNCTION update_ut_note_promemoria (
    in_utente           IN  WISE01.ut_note_promemoria.utente%TYPE,
    in_progressivo      IN  WISE01.ut_note_promemoria.progressivo%TYPE,
    in_titolo           IN  WISE01.ut_note_promemoria.titolo%TYPE,
    in_testo            IN  WISE01.ut_note_promemoria.testo%TYPE,
    in_tipologia        IN  WISE01.ut_note_promemoria.tipologia%TYPE,
    in_colore           IN  WISE01.ut_note_promemoria.colore%TYPE,
    in_data_promemoria  IN  WISE01.ut_note_promemoria.data_promemoria%TYPE,
    in_applicazione     IN  WISE01.ut_note_promemoria.applicazione%TYPE
  ) RETURN WISE01.ut_note_promemoria.progressivo%TYPE
 IS

  lc_msg          VARCHAR2(1000);
  ln_progressivo  WISE01.ut_note_promemoria.progressivo%TYPE;

BEGIN

  lc_msg := 'UPDATE ut_note_promemoria';
  UPDATE WISE01.ut_note_promemoria
     SET titolo           = in_titolo,
         testo            = in_testo,
         tipologia        = in_tipologia,
         colore           = in_colore,
         data_promemoria  = in_data_promemoria,
         cr               = cr_pck.Modifica(cr, wise01.cr_pck.get_prog_reg(cr))
	 WHERE utente           = in_utente
	   AND progressivo      = in_progressivo
	   AND applicazione     = in_applicazione;

  IF ( SQL%ROWCOUNT = 0 ) THEN

     lc_msg := 'SELECT NVL(MAX(progressivo),0) + 1';
     SELECT NVL(MAX(progressivo),0) + 1
       INTO ln_progressivo
       FROM WISE01.ut_note_promemoria
      WHERE utente           = in_utente
        AND applicazione     = in_applicazione;

      lc_msg := 'insert_ut_note_promemoria';
      insert_ut_note_promemoria (
          in_utente,
          ln_progressivo,
          in_titolo,
          in_testo,
          in_tipologia,
          in_colore,
          in_data_promemoria,
          in_applicazione
     );

     RETURN ln_progressivo;

  ELSE

   RETURN in_progressivo;

  END IF;

EXCEPTION
  WHEN OTHERS THEN
    WISE01.ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
    RAISE;
END update_ut_note_promemoria;
------------------------------------------------------------------------------------------
PROCEDURE delete_ut_note_promemoria (
	in_applicazione  IN  WISE01.ut_note_promemoria.applicazione%TYPE,
	in_utente        IN  WISE01.ut_note_promemoria.utente%TYPE,
	in_progressivo   IN  WISE01.ut_note_promemoria.progressivo%TYPE
)  IS

	lc_msg  VARCHAR2(1000);
BEGIN

	lc_msg := 'DELETE WISE01.ut_note_promemoria '||
	' WHERE applicazione='||in_applicazione||
	' AND utente='||in_utente||
	' AND progressivo='||in_progressivo;

	DELETE WISE01.ut_note_promemoria
	 WHERE applicazione  = in_applicazione
	   AND utente        = in_utente
	   AND progressivo   = in_progressivo;

EXCEPTION
	WHEN OTHERS THEN
		WISE01.ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
		RAISE;
END delete_ut_note_promemoria;

-----------------------------------------------------------------------
PROCEDURE insert_wi_preferiti (
    in_descrizione   IN wise40.wi_preferiti.descrizione%TYPE,
    in_nome          IN WISE40.wi_preferiti.nome%TYPE,
    in_tipo          IN wise40.wi_preferiti.tipo%TYPE,
    in_nome_padre    IN WISE40.wi_preferiti.nome_padre%TYPE,
    in_wtc           IN WISE40.wi_preferiti.wtc%TYPE,
    in_ordinamento   IN WISE40.wi_preferiti.ordinamento%TYPE
  )  IS

  lr_wi_preferiti  WISE40.wi_preferiti%ROWTYPE;
  lc_msg  VARCHAR2(1000);

BEGIN

  lc_msg := 'Valori in input';

  lr_wi_preferiti.nome          := in_nome;
  lr_wi_preferiti.tipo          := in_tipo;
  lr_wi_preferiti.utente        := SYS_CONTEXT('WISE01', 'UTENTE');
  lr_wi_preferiti.applicazione  := SYS_CONTEXT('WISE01', 'APPLICAZIONE');
  lr_wi_preferiti.descrizione   := in_descrizione;
  lr_wi_preferiti.nome_padre    := in_nome_padre;
  lr_wi_preferiti.wtc           := in_wtc;
  lr_wi_preferiti.ordinamento   := in_ordinamento;
  lr_wi_preferiti.cr            := cr_pck.crea;

  lc_msg := 'INSERT INTO WISE40.wi_preferiti';
  INSERT INTO WISE40.wi_preferiti VALUES lr_wi_preferiti;

EXCEPTION
  WHEN OTHERS THEN
    ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
    RAISE;

END insert_wi_preferiti;

-----------------------------------------------------------------------

PROCEDURE update_wi_preferiti (
   in_descrizione   IN wise40.wi_preferiti.descrizione%TYPE,
   in_nome          IN WISE40.wi_preferiti.nome%TYPE,
   in_tipo          IN wise40.wi_preferiti.tipo%TYPE,
   in_nome_padre    IN WISE40.wi_preferiti.nome_padre%TYPE,
   in_wtc           IN WISE40.wi_preferiti.wtc%TYPE,
   in_ordinamento   IN WISE40.wi_preferiti.ordinamento%TYPE
)  IS

  lc_msg  VARCHAR2(1000);
BEGIN

  lc_msg := 'UPDATE WISE40.wi_preferiti SET descrizione = ' || in_descrizione ||
  ', nome_padre = ' || in_nome_padre ||
  ', wtc = ' || in_wtc ||
  ', ordinamento = ' || in_ordinamento ||
  ' WHERE nome='||in_nome||
  ' AND utente='||am_pck.get_utente||
  ' AND applicazione='||am_pck.Get_Applicazione;

  UPDATE WISE40.wi_preferiti
     SET descrizione = in_descrizione,
         nome_padre  = in_nome_padre,
         wtc         = in_wtc,
         ordinamento = in_ordinamento
   WHERE nome          = in_nome
     AND tipo          = in_tipo
     AND utente        = SYS_CONTEXT('WISE01', 'UTENTE')
     AND applicazione  = SYS_CONTEXT('WISE01', 'APPLICAZIONE');

EXCEPTION
  WHEN OTHERS THEN
    ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
    RAISE;
END update_wi_preferiti;

-----------------------------------------------------------------------
PROCEDURE delete_wi_preferiti (
  in_nome          IN  WISE40.wi_preferiti.nome%TYPE,
  in_tipo          IN wise40.wi_preferiti.tipo%TYPE
)  IS

  lc_msg  VARCHAR2(1000);
BEGIN

  lc_msg := 'DELETE WISE40.wi_preferiti '||
  ' WHERE nome='||in_nome||
  ' AND utente='||SYS_CONTEXT('WISE01', 'UTENTE')||
  ' AND applicazione='||SYS_CONTEXT('WISE01', 'APPLICAZIONE');

  DELETE WISE40.wi_preferiti
   WHERE nome          = in_nome
     AND tipo          = in_tipo
     AND utente        = SYS_CONTEXT('WISE01', 'UTENTE')
     AND applicazione  = SYS_CONTEXT('WISE01', 'APPLICAZIONE');

EXCEPTION
  WHEN OTHERS THEN
    WISE01.ut_pck.oracle_log(SQLCODE, SQLERRM, lc_msg);
    RAISE;
END delete_wi_preferiti;

-- -----------------------------------------------------------------------------
-- Invia messaggio all'utente che ha un promemoria nella giornata odierna
-- -----------------------------------------------------------------------------
-- RBE 06/06/2024 prima stesura
-- -----------------------------------------------------------------------------
PROCEDURE msg_promemoria_giornalieri IS
	ln_non_letti NUMBER;
	lc_msg ut_allarmi.msg_allarme%TYPE;
	lc_oggetto_msg CONSTANT up_messaggi.oggetto%TYPE := 'Promemoria';
BEGIN

	FOR promemoria_oggi IN (
		SELECT DISTINCT n.utente
		  FROM ut_note_promemoria n
		 WHERE TRUNC(n.data_promemoria) = TRUNC(SYSDATE)
	) LOOP

		SELECT COUNT(*) INTO ln_non_letti
		  FROM up_messaggi m
		 WHERE m.destinatario = promemoria_oggi.utente
		   AND m.oggetto = lc_oggetto_msg
			AND NVL(m.f_lettura,FLAG_N) = FLAG_N;

		IF ln_non_letti > 0 THEN
		 	CONTINUE;
		END IF;

		up_pck.invia_messaggio(
			promemoria_oggi.utente,
			up_pck.UP_TIPO_DEST_UTENTE,
			promemoria_oggi.utente,
			lc_oggetto_msg,
			'Hai dei promemoria in data odierna',
			up_pck.UP_SEVERITA_MESSAGGIO_CONFERMA);

	END LOOP;


EXCEPTION
   WHEN OTHERS THEN
      ut_pck.oracle_log(SQLCODE,SQLERRM,lc_msg);
      RAISE;
END msg_promemoria_giornalieri;

-- -----------------------------------------------------------------------------
-- Procedura attaccata a interfaccia W-Lib per generare Token tramite apposito package di hashing
-- NB. Il token restituito dal package interno non viene restituito a W-Lib per scelta
-- -----------------------------------------------------------------------------
-- RGI 13/06/2024 prima stesura
-- -----------------------------------------------------------------------------

PROCEDURE genera_token_pwd(
  in_utente IN up_utenti.utente%TYPE
) IS
  lc_msg ut_allarmi.msg_allarme%TYPE;

BEGIN

  lc_msg := 'wise01.up_autenticazione_hash_pck.genera_token_cambio_pwd(''' ||in_utente || ''');';
  lc_msg := wise01.up_autenticazione_hash_pck.genera_token_cambio_pwd(in_utente);

EXCEPTION
   WHEN OTHERS THEN
      ut_pck.oracle_log(SQLCODE,SQLERRM,lc_msg);
      RAISE;
END genera_token_pwd;

-- -----------------------------------------------------------------------------
-- Procedura attaccata a wi_procedura standard per cambio password tramite token e doppia password hashata
-- -----------------------------------------------------------------------------
-- RGI 13/06/2024 prima stesura
-- -----------------------------------------------------------------------------

PROCEDURE cambio_password_hash_token(
	in_utente                   IN up_utenti.utente%TYPE,
	in_token                    IN up_token_utente.token%TYPE,
	in_nuova_password           IN up_utenti.hash_password%TYPE,
	in_conferma_nuova_password  IN up_utenti.hash_password%TYPE
) IS

	lc_msg ut_allarmi.msg_allarme%TYPE;
	lr_salt          up_utenti.salt%TYPE;
	lr_hash_salt_pwd up_utenti.hash_password%TYPE;

BEGIN

	IF utl_raw.compare(in_nuova_password, in_conferma_nuova_password) != 0 THEN
		ut_pck.raise_log('PWD_UTENTE_NON_CONFERMATA', Ut_Pck.UT_INFO,
			'La nuova password per l''utente %1 non coincide con la sua conferma',
			in_utente);
	END IF;

	lc_msg := 'wise01.up_utenti WHERE utente = '||in_utente;
	SELECT salt INTO lr_salt
	FROM wise01.up_utenti
	WHERE utente = in_utente;

	-- concatena salt + pwd ed asha
	lr_hash_salt_pwd := up_autenticazione_hash_pck.get_hashed_pwd_hash(in_nuova_password,lr_salt);

	lc_msg := 'wise01.up_autenticazione_hash_pck.cambia_password_token('||in_utente||', in_token, in_nuova_password);';
	wise01.up_autenticazione_hash_pck.cambia_password_token(in_utente, in_token, lr_hash_salt_pwd);

EXCEPTION
   WHEN OTHERS THEN
      ut_pck.oracle_log(SQLCODE,SQLERRM,lc_msg);
      RAISE;
END cambio_password_hash_token;

-- -----------------------------------------------------------------------------
-- Procedura attaccata a wi_procedura standard per cambio password tramite doppia password hashata
-- -----------------------------------------------------------------------------
-- RGI 13/06/2024 prima stesura
-- -----------------------------------------------------------------------------

PROCEDURE cambio_password_hash (
	in_utente                   IN up_utenti.utente%TYPE,
	in_pwd_attuale              IN up_utenti.hash_password%TYPE,
	in_nuova_password           IN up_utenti.hash_password%TYPE,
	in_conferma_nuova_password  IN up_utenti.hash_password%TYPE
) IS

	lc_msg           ut_allarmi.msg_allarme%TYPE;
	lr_hash_salt_pwd_att up_utenti.hash_password%TYPE;
	lr_hash_salt_pwd_new up_utenti.hash_password%TYPE;
	lr_salt_utente up_utenti.salt%TYPE;


BEGIN

	IF is_utente_dominio(in_utente) THEN
		ut_pck.raise_log('UTENTE_DOMINIO', ut_pck.UT_FATAL,'Impossibile cambiare la password di un utente di dominio');
	END IF;

	IF utl_raw.compare(in_nuova_password, in_conferma_nuova_password) != 0 THEN
		Ut_Pck.raise_log('PWD_UTENTE_NON_CONFERMATA', Ut_Pck.UT_INFO,
							  'La nuova password per l''utente %1 non coincide con la sua conferma', in_utente);
	END IF;

	lc_msg := 'FROM wise01.up_utenti	WHERE utente = '||in_utente;
	SELECT salt INTO lr_salt_utente
	FROM wise01.up_utenti
	WHERE utente = in_utente;


	lr_hash_salt_pwd_att := up_autenticazione_hash_pck.get_hashed_pwd_hash(in_pwd_attuale, lr_salt_utente);
	lr_hash_salt_pwd_new := up_autenticazione_hash_pck.get_hashed_pwd_hash(in_nuova_password, lr_salt_utente);

	lc_msg := 'wise01.up_autenticazione_hash_pck.cambia_password_token('||in_utente||', in_token, in_nuova_password);';
	wise01.up_autenticazione_hash_pck.cambia_password_loggato(in_utente, lr_hash_salt_pwd_att, lr_hash_salt_pwd_new);

EXCEPTION
   WHEN OTHERS THEN
      ut_pck.oracle_log(SQLCODE,SQLERRM,lc_msg);
      RAISE;
END cambio_password_hash;

END up_pck ;
/

