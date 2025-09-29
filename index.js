const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const axios = require('axios');
admin.initializeApp();
const app = express();
app.use(cors({origin:true}));
app.use(express.json());

async function verifyIdToken(req,res,next){
  const auth = req.headers.authorization || '';
  if(!auth.startsWith('Bearer ')) return res.status(401).json({error:'Missing token'});
  const idToken = auth.split('Bearer ')[1];
  try{ req.user = await admin.auth().verifyIdToken(idToken); return next(); }
  catch(e){ return res.status(401).json({error:'Invalid token'});}
}

app.post('/mentor', verifyIdToken, async (req,res)=>{
  try{
    const {prompt, provider='openai'} = req.body;
    if(!prompt) return res.status(400).json({error:'prompt required'});
    const system='You are a helpful mentor.';
    if(provider==='openai'){
      const OPENAI_KEY = functions.config().openai?.key;
      if(!OPENAI_KEY) return res.status(500).json({error:'OpenAI key not configured'});
      const messages=[{role:'system',content:system},{role:'user',content:prompt}];
      const resp = await axios.post('https://api.openai.com/v1/chat/completions',
        {model:'gpt-4o-mini', messages, max_tokens:500},
        {headers:{'Authorization':`Bearer ${OPENAI_KEY}`,'Content-Type':'application/json'}});
      const content = resp.data?.choices?.[0]?.message?.content || '';
      return res.json({response:content});
    } else if(provider==='anthropic'){
      const ANTH_KEY = functions.config().anthropic?.key;
      if(!ANTH_KEY) return res.status(500).json({error:'Anthropic key not configured'});
      const promptText = `System: ${system}\nHuman: ${prompt}\nAssistant:`;
      const resp = await axios.post('https://api.anthropic.com/v1/complete',
        {model:'claude-2.1', prompt: promptText, max_tokens_to_sample:500},
        {headers:{'x-api-key': ANTH_KEY,'Content-Type':'application/json'}});
      const text = resp.data?.completion || '';
      return res.json({response:text});
    } else return res.status(400).json({error:'unknown provider'});
  } catch(err){ console.error(err); return res.status(500).json({error:'server error'}); }
});

exports.api = functions.https.onRequest(app);
